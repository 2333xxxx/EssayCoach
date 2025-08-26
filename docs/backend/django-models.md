# Django Models

## 🏗️ Model Architecture Overview

The EssayCoach backend uses Django's ORM with an existing database schema that's optimized for educational workflows. The models are configured as `managed = False` to work with the existing database structure while providing Django authentication capabilities.

## 📋 Core Models

### User Management Models

#### Custom User Model
```python
# core/models.py
from django.contrib.auth.base_user import AbstractBaseUser, BaseUserManager
from django.contrib.auth.models import PermissionsMixin
from django.db import models

class CoreUserManager(BaseUserManager):
    def create_user(self, user_email, password=None, **extra_fields):
        if not user_email:
            raise ValueError("Users must have an email address")
        email = self.normalize_email(user_email)
        user = self.model(user_email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, user_email, password, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        return self.create_user(user_email, password, **extra_fields)

class User(AbstractBaseUser, PermissionsMixin):
    """Custom user model aligned with existing database schema"""
    user_id = models.IntegerField(primary_key=True, db_column='user_id')
    user_email = models.EmailField(unique=True, db_column='user_email')
    user_fname = models.CharField(max_length=20, blank=True, null=True, db_column='user_fname')
    user_lname = models.CharField(max_length=20, blank=True, null=True, db_column='user_lname')
    user_role = models.CharField(max_length=10, blank=True, null=True, db_column='user_role')
    user_status = models.CharField(max_length=15, blank=True, null=True, db_column='user_status')
    password = models.CharField(max_length=255, db_column='user_credential')
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    date_joined = models.DateTimeField(auto_now_add=True)

    objects = CoreUserManager()

    USERNAME_FIELD = 'user_email'
    EMAIL_FIELD = 'user_email'
    REQUIRED_FIELDS = []

    class Meta:
        db_table = 'user'
        managed = False
        db_table_comment = 'A table for all user entities, including student, teacher, and admins.'

    def __str__(self):
        if self.user_fname or self.user_lname:
            return f"{self.user_fname or ''} {self.user_lname or ''} <{self.user_email}>".strip()
        return self.user_email

    def get_full_name(self):
        return f"{self.user_fname or ''} {self.user_lname or ''}".strip()

    def get_short_name(self):
        return self.user_fname or self.user_email
```

### Educational Structure Models

#### Unit Model
```python
# core/models.py
class Unit(models.Model):
    """Academic unit/course entity"""
    unit_id = models.CharField(primary_key=True, max_length=10, db_comment='Unique identifier for each unit, same as the unit code')
    unit_name = models.CharField(max_length=50, db_comment='Full name of the unit')
    unit_desc = models.TextField(blank=True, null=True, db_comment='details of the unit')

    class Meta:
        managed = False
        db_table = 'unit'
        db_table_comment = 'A table for unit entity'
```

#### Class Model
```python
# core/models.py
class Class(models.Model):
    """Class entity under a unit"""
    class_id = models.SmallAutoField(primary_key=True, db_comment='Unique identifier for a class under a unit')
    unit_id_unit = models.ForeignKey('Unit', models.DO_NOTHING, db_column='unit_id_unit')
    class_size = models.SmallIntegerField(db_comment='current number of students in the class')

    class Meta:
        managed = False
        db_table = 'class'
        db_table_comment = 'A table for class entity'
        verbose_name = 'class'
        verbose_name_plural = 'classes'
```

#### Enrollment Model
```python
# core/models.py
class Enrollment(models.Model):
    """Student enrollment in classes"""
    enrollment_id = models.AutoField(primary_key=True, db_comment='Unique identifier for each enrollment')
    user_id_user = models.ForeignKey('User', models.DO_NOTHING, db_column='user_id_user')
    class_id_class = models.ForeignKey(Class, models.DO_NOTHING, db_column='class_id_class')
    unit_id_unit = models.ForeignKey('Unit', models.DO_NOTHING, db_column='unit_id_unit')
    enrollment_time = models.DateTimeField(db_comment='The time when the student is enrolled in the DBMS')

    class Meta:
        managed = False
        db_table = 'enrollment'
        unique_together = (('user_id_user', 'class_id_class', 'unit_id_unit'),)
        db_table_comment = 'The enrollment of student to a specific class. A student can only have one enrollment to one class of one unit anytime.'
```

#### Teaching Assignment Model
```python
# core/models.py
class TeachingAssn(models.Model):
    """Assignment of teachers to classes"""
    teaching_assn_id = models.SmallAutoField(primary_key=True, db_comment='unique identifier')
    user_id_user = models.ForeignKey('User', models.DO_NOTHING, db_column='user_id_user')
    class_id_class = models.ForeignKey(Class, models.DO_NOTHING, db_column='class_id_class')

    class Meta:
        managed = False
        db_table = 'teaching_assn'
        unique_together = (('user_id_user', 'class_id_class'),)
        db_table_comment = 'A weak entity for assignment of teacher to classes'
```

### Task and Submission Models

#### Task Model
```python
# core/models.py
class Task(models.Model):
    """Tasks created by educators for students"""
    task_id = models.AutoField(primary_key=True, db_comment='Unique identifier for task.')
    unit_id_unit = models.ForeignKey('Unit', models.DO_NOTHING, db_column='unit_id_unit')
    rubric_id_marking_rubric = models.ForeignKey('MarkingRubric', models.DO_NOTHING, db_column='rubric_id_marking_rubric')
    task_publish_datetime = models.DateTimeField(db_comment='time/date when the task is published')
    task_due_datetime = models.DateTimeField(db_comment='time/date when the task is due')

    class Meta:
        managed = False
        db_table = 'task'
        db_table_comment = 'Task created by lecturer/admin for students in some classes/units to complete'
```

#### Submission Model
```python
# core/models.py
class Submission(models.Model):
    """Essay submissions for tasks"""
    submission_id = models.AutoField(primary_key=True, db_comment='unique identifier for submission')
    submission_time = models.DateTimeField(db_comment='time/date of submission')
    task_id_task = models.ForeignKey('Task', models.DO_NOTHING, db_column='task_id_task')
    user_id_user = models.ForeignKey('User', models.DO_NOTHING, db_column='user_id_user')
    submission_txt = models.TextField(db_comment='complete content of the essay submission')

    class Meta:
        managed = False
        db_table = 'submission'
        db_table_comment = 'A real entity for task submissions.'
```

### Assessment and Feedback Models

#### Marking Rubric Model
```python
# core/models.py
class MarkingRubric(models.Model):
    """Marking rubrics for assessment"""
    rubric_id = models.AutoField(primary_key=True, db_comment='unique identifier for rubrics')
    user_id_user = models.ForeignKey('User', models.DO_NOTHING, db_column='user_id_user')
    rubric_create_time = models.DateTimeField(db_comment='timestamp when the rubirc is created')
    rubric_desc = models.CharField(max_length=100, blank=True, null=True, db_comment='description to the rubrics')

    class Meta:
        managed = False
        db_table = 'marking_rubric'
        db_table_comment = 'entity for a marking rubric. A marking rubric has many items.'
```

#### Rubric Item Model
```python
# core/models.py
class RubricItem(models.Model):
    """Individual items within a rubric"""
    rubric_item_id = models.AutoField(primary_key=True, db_comment='unique identifier for item')
    rubric_id_marking_rubric = models.ForeignKey(MarkingRubric, models.DO_NOTHING, db_column='rubric_id_marking_rubric')
    rubric_item_name = models.CharField(max_length=50, db_comment='Title(header) name for the item')
    rubric_item_weight = models.DecimalField(max_digits=3, decimal_places=1, db_comment='the weight of the item on a scale of 100%, using xx.x')

    class Meta:
        managed = False
        db_table = 'rubric_item'
        db_table_comment = 'An item(dimension) under one rubric'
```

#### Rubric Level Description Model
```python
# core/models.py
class RubricLevelDesc(models.Model):
    """Detailed descriptions for score ranges in rubric items"""
    level_desc_id = models.AutoField(primary_key=True, db_comment='unique identifier for each level desc under one rubric')
    rubric_item_id_rubric_item = models.ForeignKey(RubricItem, models.DO_NOTHING, db_column='rubric_item_id_rubric_item')
    level_min_score = models.SmallIntegerField(db_comment='min for the item')
    level_max_score = models.SmallIntegerField(db_comment='max for the item')
    level_desc = models.TextField()

    class Meta:
        managed = False
        db_table = 'rubric_level_desc'
        db_table_comment = 'The detailed description to each of the score range under a rubric item under a rubric.'
```

#### Feedback Model
```python
# core/models.py
class Feedback(models.Model):
    """Feedback for submissions"""
    feedback_id = models.AutoField(primary_key=True)
    submission_id_submission = models.OneToOneField('Submission', models.DO_NOTHING, db_column='submission_id_submission')
    user_id_user = models.ForeignKey('User', models.DO_NOTHING, db_column='user_id_user')

    class Meta:
        managed = False
        db_table = 'feedback'
```

#### Feedback Item Model
```python
# core/models.py
class FeedbackItem(models.Model):
    """Individual feedback items with scores"""
    feedback_item_id = models.AutoField(primary_key=True, db_comment='unique identifier for feedback item')
    feedback_id_feedback = models.ForeignKey(Feedback, models.DO_NOTHING, db_column='feedback_id_feedback')
    rubric_item_id_rubric_item = models.ForeignKey('RubricItem', models.DO_NOTHING, db_column='rubric_item_id_rubric_item')
    feedback_item_score = models.SmallIntegerField(db_comment='actual score of the item')
    feedback_item_comment = models.TextField(blank=True, null=True, db_comment='short description to the sub-item grade')
    feedback_item_source = models.CharField(max_length=10, db_comment='the source of feedback: \nai, human, or revised if ai feedback is slightly modifed by human')

    class Meta:
        managed = False
        db_table = 'feedback_item'
        unique_together = (('feedback_id_feedback', 'rubric_item_id_rubric_item'),)
        db_table_comment = 'A section in the feedback as per the rubric'
```

## 🔄 Model Relationships

### Relationship Diagram
```
User (1) ----< (Many) Submission
User (1) ----< (Many) Enrollment
User (1) ----< (Many) TeachingAssn
User (1) ----< (Many) MarkingRubric
User (1) ----< (Many) Feedback

Unit (1) ----< (Many) Class
Unit (1) ----< (Many) Task
Unit (1) ----< (Many) Enrollment

Class (1) ----< (Many) Enrollment
Class (1) ----< (Many) TeachingAssn

Task (1) ----< (Many) Submission
Task (Many) >---- (1) MarkingRubric

Submission (1) ----< (1) Feedback
Feedback (1) ----< (Many) FeedbackItem

MarkingRubric (1) ----< (Many) RubricItem
RubricItem (1) ----< (Many) RubricLevelDesc
RubricItem (1) ----< (Many) FeedbackItem
```

### Key Relationships Explained

1. **Educational Structure**:
   - Units contain multiple Classes
   - Users can be enrolled in Classes through Enrollment
   - Teachers are assigned to Classes through TeachingAssn

2. **Assessment Flow**:
   - Tasks are created for Units with associated MarkingRubrics
   - Students submit Submissions for Tasks
   - Each Submission gets one Feedback
   - Feedback contains multiple FeedbackItems linked to RubricItems

3. **Rubric Structure**:
   - MarkingRubrics contain multiple RubricItems
   - Each RubricItem has multiple RubricLevelDesc for score ranges
   - FeedbackItems reference specific RubricItems for scoring

## 🎯 Model Best Practices

### Database Schema Considerations

Since all models are configured with `managed = False`, they work with an existing database schema. This approach:

- **Preserves existing data structure** while providing Django ORM capabilities
- **Requires manual database migrations** for schema changes
- **Uses custom field mappings** via `db_column` to match existing column names
- **Maintains referential integrity** through existing database constraints

### Performance Optimizations
```python
# Use select_related for foreign keys to reduce queries
submissions = Submission.objects.select_related('user', 'task', 'task__unit')

# Use prefetch_related for reverse foreign keys
users = User.objects.prefetch_related('submissions__feedback')

# Use only() for specific fields to reduce memory usage
tasks = Task.objects.only('task_id', 'task_publish_datetime', 'task_due_datetime')

# Use values() for aggregations
submission_stats = Submission.objects.values('user_id_user').annotate(count=Count('submission_id'))
```

### Query Optimization for Educational Schema
```python
# Get all classes for a user (student or teacher)
def get_user_classes(user):
    if user.user_role == 'student':
        return Class.objects.filter(enrollment__user_id_user=user)
    elif user.user_role == 'lecturer':
        return Class.objects.filter(teachingassn__user_id_user=user)
    return Class.objects.none()

# Get submissions with feedback for a class
def get_class_submissions_with_feedback(class_id):
    return Submission.objects.filter(
        task__unit__class__class_id=class_id
    ).select_related(
        'user', 'task', 'feedback'
    ).prefetch_related(
        'feedback__feedbackitem_set'
    )

# Get rubric-based feedback summary
def get_rubric_feedback_summary(submission_id):
    return FeedbackItem.objects.filter(
        feedback_id_feedback__submission_id_submission=submission_id
    ).select_related('rubric_item_id_rubric_item')
```

### Database Constraints and Validation
```python
# Example of custom validation for submission word count
class Submission(models.Model):
    def clean(self):
        word_count = len(self.submission_txt.split())
        if word_count < 50:
            raise ValidationError('Submission must be at least 50 words')
        if word_count > 5000:
            raise ValidationError('Submission cannot exceed 5000 words')
    
    def save(self, *args, **kwargs):
        self.full_clean()
        super().save(*args, **kwargs)

# Existing database constraints are maintained:
# - Unique constraints on enrollment (user, class, unit)
# - Unique constraints on teaching assignments (user, class)
# - Foreign key relationships maintained at database level
```

### Working with Managed=False Models

```python
# When working with unmanaged models:

# 1. Always use existing database constraints
# 2. Perform schema changes manually or through SQL migrations
# 3. Test queries against the actual database structure
# 4. Use db_column to map Django field names to database columns
# 5. Leverage existing database indexes and constraints

# Example of complex query with joins
def get_student_performance_in_unit(student_id, unit_id):
    return Submission.objects.filter(
        user_id_user=student_id,
        task__unit_id_unit=unit_id
    ).select_related(
        'task', 'feedback'
    ).prefetch_related(
        'feedback__feedbackitem_set__rubric_item_id_rubric_item'
    ).order_by('submission_time')
```