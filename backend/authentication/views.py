from rest_framework import generics, permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

from .models import User
from .serializers import (
    CustomTokenObtainPairSerializer,
    RegisterSerializer,
    UserDetailSerializer,
)


class RegisterView(generics.CreateAPIView):
    """
    POST /api/v1/auth/register/
    Registers a new user with Law 1581 (Habeas Data) validation.
    """
    queryset = User.objects.all()
    serializer_class = RegisterSerializer
    permission_classes = [permissions.AllowAny]

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()
        response_data = {
            "message": "Usuario registrado exitosamente.",
            "user": {
                "id": user.id,
                "email": user.email,
                "role": user.role,
                "habeas_data_consent": user.habeas_data_consent,
                "consent_date": user.consent_date.isoformat() if user.consent_date else None,
            }
        }
        return Response(response_data, status=status.HTTP_201_CREATED)


class CustomLoginView(TokenObtainPairView):
    """
    POST /api/v1/auth/login/
    Custom SimpleJWT login view returning access, refresh, role, and email.
    """
    permission_classes = [permissions.AllowAny]
    serializer_class = CustomTokenObtainPairSerializer


class CurrentUserView(generics.RetrieveAPIView):
    """
    GET /api/v1/auth/me/
    Returns full profile details for the currently authenticated user.
    """
    serializer_class = UserDetailSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_object(self):
        return self.request.user


class HealthCheckView(APIView):
    """
    GET /api/v1/auth/health/
    Unprotected health probe for GCP load balancers and system monitoring.
    """
    permission_classes = [permissions.AllowAny]

    def get(self, request, *args, **kwargs):
        return Response({
            "status": "healthy",
            "service": "conecta-nexus-auth-service",
            "compliance": "Ley 1581 de 2012 (Habeas Data) Active"
        }, status=status.HTTP_200_OK)
