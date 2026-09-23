from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from django.utils.translation import gettext_lazy as _

from .models import User


@admin.register(User)
class UserAdmin(BaseUserAdmin):
    """
    Admin configuration for the custom User model.
    """
    ordering = ('email',)
    list_display = (
        'email',
        'role',
        'habeas_data_consent',
        'consent_date',
        'is_staff',
        'is_active',
    )
    list_filter = ('role', 'habeas_data_consent', 'is_staff', 'is_active')
    search_fields = ('email',)

    fieldsets = (
        (None, {'fields': ('email', 'password')}),
        (_('Rol y Permisos'), {'fields': ('role', 'is_active', 'is_staff', 'is_superuser', 'groups', 'user_permissions')}),
        (_('Cumplimiento Legal (Ley 1581 de 2012)'), {'fields': ('habeas_data_consent', 'consent_date')}),
        (_('Fechas Importantes'), {'fields': ('last_login', 'date_joined')}),
    )

    add_fieldsets = (
        (
            None,
            {
                'classes': ('wide',),
                'fields': ('email', 'password1', 'password2', 'role', 'habeas_data_consent'),
            },
        ),
    )
