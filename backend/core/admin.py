"""
This file is used to register the models in the admin interface.
We have overridden the built-in UserAdmin and User entity to add additional fields from
our own database schema. For more information, see:

Substituting a custom User model
https://docs.djangoproject.com/en/stable/topics/auth/customizing/#substituting-a-custom-user-model


UserAdmin reference (describes fieldsets, add_fieldsets, etc.)
https://docs.djangoproject.com/en/stable/ref/contrib/auth/#django.contrib.auth.admin.UserAdmin


General ModelAdmin options (list_display, list_filter, search_fields, ordering, filter_horizontal)
https://docs.djangoproject.com/en/stable/ref/contrib/admin/#modeladmin-options


Details on fieldsets option
https://docs.djangoproject.com/en/stable/ref/contrib/admin/#django.contrib.admin.ModelAdmin.fieldsets
"""

from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from django.utils.translation import gettext_lazy as _
from .models import (
    User, Unit, Class, Enrollment, TeachingAssn,
    MarkingRubric, RubricItem, RubricLevelDesc,
    Task, Submission, Feedback, FeedbackItem
)

class CustomUserAdmin(BaseUserAdmin):
    # Fields to display in the admin interface.
    fieldsets = (
        (None, {'fields': ('user_email', 'password')}),
        (_('Personal info'), {'fields': ('user_fname', 'user_lname', 'user_role', 'user_status')}),
        (_('Permissions'), {
            'fields': ('is_active', 'is_staff', 'is_superuser', 'groups', 'user_permissions'),
        }),
        (_('Important dates'), {'fields': ('last_login', 'date_joined')}),
    )
    
    # Fields to add when create a new user.
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('user_email', 'password1', 'password2'),
        }),
    )
    
    # To display in the admin interface.
    list_display = ('user_email', 'user_fname', 'user_lname', 'user_role', 'user_status', 'is_staff')
    list_filter = ('is_staff', 'is_superuser', 'is_active', 'user_role', 'user_status')
    
    # Searching field.
    search_fields = ('user_email', 'user_fname', 'user_lname')
    
    # Ordering of the user list.
    ordering = ('user_email',)
    
    # To display the user groups and permissions in a horizontal filter.
    filter_horizontal = ('groups', 'user_permissions')

# Register your models here.
admin.site.register(User, CustomUserAdmin)
admin.site.register(Unit)
admin.site.register(Class)
admin.site.register(Enrollment)
admin.site.register(TeachingAssn)
admin.site.register(MarkingRubric)
admin.site.register(RubricItem)
admin.site.register(RubricLevelDesc)
admin.site.register(Task)
admin.site.register(Submission)
admin.site.register(Feedback)
admin.site.register(FeedbackItem)
