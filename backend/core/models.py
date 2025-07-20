from django.db import models
from django.contrib.auth.models import AbstractUser


class User(AbstractUser):
    """Central user entity for students, lecturers, and admins"""
    pass


class Unit(models.Model):
    """Academic unit/course entity"""
    pass


class Class(models.Model):
    """Class section under a unit"""
    pass


class Enrollment(models.Model):
    """Student enrollment in a class"""
    pass


class TeachingAssignment(models.Model):
    """Teacher assignment to classes"""
    pass


class MarkingRubric(models.Model):
    """Marking rubric created by lecturers"""
    pass


class RubricItem(models.Model):
    """Individual criteria within a rubric"""
    pass


class RubricLevelDesc(models.Model):
    """Score level descriptions for rubric items"""
    pass


class Task(models.Model):
    """Assignment tasks created for units"""
    pass


class Submission(models.Model):
    """Student essay submissions"""
    pass


class Feedback(models.Model):
    """Feedback given on submissions"""
    pass


class FeedbackItem(models.Model):
    """Individual feedback items per rubric criteria"""
    pass
