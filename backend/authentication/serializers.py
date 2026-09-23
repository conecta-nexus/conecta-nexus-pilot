from django.utils import timezone
from rest_framework import serializers
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer

from .models import User


class RegisterSerializer(serializers.ModelSerializer):
    """
    Serializer for user registration enforcing Law 1581 of 2012 (Habeas Data)
    and role validation for academic or corporate profiles.
    """
    password = serializers.CharField(
        write_only=True,
        required=True,
        min_length=6,
        style={'input_type': 'password'},
        help_text="Contraseña segura (mínimo 6 caracteres)"
    )

    class Meta:
        model = User
        fields = ('id', 'email', 'password', 'role', 'habeas_data_consent', 'consent_date')
        read_only_fields = ('id', 'consent_date')

    def validate_habeas_data_consent(self, value):
        if value is not True:
            raise serializers.ValidationError(
                "Debe autorizar de manera previa y explícita el tratamiento de sus datos "
                "personales conforme a la Ley 1581 de 2012 (Habeas Data) para continuar."
            )
        return value

    def validate_role(self, value):
        allowed_roles = [User.RoleChoices.ESTUDIANTE, User.RoleChoices.EMPRESA]
        if value not in allowed_roles:
            raise serializers.ValidationError(
                f"El rol debe ser '{User.RoleChoices.ESTUDIANTE}' o '{User.RoleChoices.EMPRESA}'."
            )
        return value

    def create(self, validated_data):
        password = validated_data.pop('password')
        validated_data['consent_date'] = timezone.now()
        user = User.objects.create_user(password=password, **validated_data)
        return user


class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):
    """
    Custom SimpleJWT serializer that injects user metadata into claims
    and returns essential identity fields in the response payload.
    """

    @classmethod
    def get_token(cls, user):
        token = super().get_token(user)

        # Custom claims embedded into JWT access token
        token['user_id'] = user.id
        token['email'] = user.email
        token['role'] = user.role
        token['habeas_data_consent'] = user.habeas_data_consent

        return token

    def validate(self, attrs):
        data = super().validate(attrs)

        # Enriched response payload returned upon successful login
        data['user_id'] = self.user.id
        data['email'] = self.user.email
        data['role'] = self.user.role
        data['habeas_data_consent'] = self.user.habeas_data_consent
        data['consent_date'] = self.user.consent_date.isoformat() if self.user.consent_date else None

        return data


class UserDetailSerializer(serializers.ModelSerializer):
    """
    Serializer providing complete profile details for authenticated user (/me/).
    """

    class Meta:
        model = User
        fields = (
            'id',
            'email',
            'role',
            'habeas_data_consent',
            'consent_date',
            'date_joined',
            'is_active',
        )
        read_only_fields = fields
