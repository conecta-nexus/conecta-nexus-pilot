from django.contrib.auth.base_user import BaseUserManager
from django.contrib.auth.models import AbstractUser
from django.db import models
from django.utils import timezone
from django.utils.translation import gettext_lazy as _


class UserManager(BaseUserManager):
    """
    Custom user manager where email is the unique identifiers
    for authentication instead of usernames.
    """

    def create_user(self, email, password=None, **extra_fields):
        if not email:
            raise ValueError(_('El correo electrónico es obligatorio'))
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        if password:
            user.set_password(password)
        else:
            user.set_unusable_password()
        user.save(using=self._db)
        return user

    def create_superuser(self, email, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        extra_fields.setdefault('is_active', True)
        extra_fields.setdefault('role', User.RoleChoices.ADMIN)
        extra_fields.setdefault('habeas_data_consent', True)
        extra_fields.setdefault('consent_date', timezone.now())

        if extra_fields.get('is_staff') is not True:
            raise ValueError(_('El superusuario debe tener is_staff=True.'))
        if extra_fields.get('is_superuser') is not True:
            raise ValueError(_('El superusuario debe tener is_superuser=True.'))

        return self.create_user(email, password, **extra_fields)


class User(AbstractUser):
    """
    Custom User Model for Conecta Nexus auth-service.
    Identified strictly by email, with RBAC roles and Law 1581 compliance.
    """

    class RoleChoices(models.TextChoices):
        ESTUDIANTE = 'ESTUDIANTE', _('Estudiante')
        EMPRESA = 'EMPRESA', _('Empresa')
        ADMIN = 'ADMIN', _('Administrador')

    username = None
    email = models.EmailField(_('correo electrónico'), unique=True)
    role = models.CharField(
        max_length=20,
        choices=RoleChoices.choices,
        default=RoleChoices.ESTUDIANTE,
        verbose_name=_('rol')
    )
    habeas_data_consent = models.BooleanField(
        default=False,
        verbose_name=_('consentimiento Ley 1581 de 2012 (Habeas Data)')
    )
    consent_date = models.DateTimeField(
        null=True,
        blank=True,
        verbose_name=_('fecha y hora de consentimiento')
    )

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = []

    objects = UserManager()

    class Meta:
        verbose_name = _('usuario')
        verbose_name_plural = _('usuarios')
        ordering = ['-date_joined']

    def __str__(self):
        return f"{self.email} ({self.role})"
