from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from .models import (
    User, Unit, Class, Enrollment, TeachingAssn,
    MarkingRubric, RubricItem, RubricLevelDesc,
    Task, Submission, Feedback, FeedbackItem
)

# Register your models here.
# We'll add detailed admin configurations later

admin.site.register(User, BaseUserAdmin)
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
