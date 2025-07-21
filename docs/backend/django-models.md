# Django Models

## 🏗️ Model Architecture Overview

The EssayCoach backend uses Django's ORM to create a robust, normalized database schema optimized for educational workflows and AI processing.

## 📋 Core Models

### User Management Models

#### Extended User Model
```python
# auth/models.py
from django.contrib.auth.models import AbstractUser
from django.db import models

class User(AbstractUser):
    """Extended user model with educational roles"""
    
    class Role(models.TextChoices):
        STUDENT = 'student', 'Student'
        EDUCATOR = 'educator', 'Educator'
        ADMIN = 'admin', 'Administrator'
    
    role = models.CharField(max_length=20, choices=Role.choices, default=Role.STUDENT)
    institution = models.CharField(max_length=100, blank=True)
    grade_level = models.CharField(max_length=20, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'users'
        indexes = [
            models.Index(fields=['role', 'institution']),
            models.Index(fields=['email']),
        ]

class UserProfile(models.Model):
    """Extended user profile information"""
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='profile')
    bio = models.TextField(max_length=500, blank=True)
    avatar = models.ImageField(upload_to='avatars/', blank=True, null=True)
    timezone = models.CharField(max_length=50, default='UTC')
    preferences = models.JSONField(default=dict, blank=True)
    
    class Meta:
        db_table = 'user_profiles'
```

### Essay Management Models

#### Essay Model
```python
# essay_submission/models.py
from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()

class Category(models.Model):
    """Essay categories for organization"""
    name = models.CharField(max_length=50, unique=True)
    description = models.TextField(blank=True)
    academic_level = models.CharField(max_length=20, choices=[
        ('elementary', 'Elementary'),
        ('middle', 'Middle School'),
        ('high', 'High School'),
        ('undergraduate', 'Undergraduate'),
        ('graduate', 'Graduate'),
    ])
    is_active = models.BooleanField(default=True)
    
    class Meta:
        db_table = 'categories'
        verbose_name_plural = 'categories'

class Essay(models.Model):
    """Core essay submission model"""
    
    class Status(models.TextChoices):
        DRAFT = 'draft', 'Draft'
        SUBMITTED = 'submitted', 'Submitted'
        PROCESSING = 'processing', 'Processing'
        COMPLETED = 'completed', 'Completed'
        FAILED = 'failed', 'Failed'
    
    title = models.CharField(max_length=200)
    content = models.TextField()
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='essays')
    category = models.ForeignKey(Category, on_delete=models.SET_NULL, null=True)
    status = models.CharField(max_length=20, choices=Status.choices, default=Status.DRAFT)
    
    # Metrics
    word_count = models.PositiveIntegerField(default=0)
    character_count = models.PositiveIntegerField(default=0)
    reading_time_minutes = models.PositiveIntegerField(default=0)
    
    # AI Processing
    ai_processing_status = models.CharField(max_length=20, default='pending')
    processing_started_at = models.DateTimeField(null=True, blank=True)
    processing_completed_at = models.DateTimeField(null=True, blank=True)
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    submitted_at = models.DateTimeField(null=True, blank=True)
    
    class Meta:
        db_table = 'essays'
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['user', 'status']),
            models.Index(fields=['status', 'created_at']),
            models.Index(fields=['category', 'created_at']),
        ]

class EssayVersion(models.Model):
    """Version control for essay submissions"""
    essay = models.ForeignKey(Essay, on_delete=models.CASCADE, related_name='versions')
    version_number = models.PositiveIntegerField()
    content = models.TextField()
    word_count = models.PositiveIntegerField(default=0)
    change_summary = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'essay_versions'
        unique_together = ['essay', 'version_number']
        ordering = ['-version_number']
```

### AI Feedback Models

#### Feedback System
```python
# ai_feedback/models.py
from django.db import models
from essay_submission.models import Essay

class FeedbackType(models.Model):
    """Types of AI feedback"""
    name = models.CharField(max_length=50, unique=True)
    description = models.TextField()
    weight = models.FloatField(default=1.0, help_text="Weight in overall scoring")
    is_active = models.BooleanField(default=True)
    order = models.PositiveIntegerField(default=0)
    
    class Meta:
        db_table = 'feedback_types'
        ordering = ['order', 'name']

class Feedback(models.Model):
    """AI-generated feedback for essays"""
    essay = models.ForeignKey(Essay, on_delete=models.CASCADE, related_name='feedback')
    type = models.ForeignKey(FeedbackType, on_delete=models.CASCADE)
    
    # Scoring
    score = models.FloatField(validators=[MinValueValidator(0.0), MaxValueValidator(100.0)])
    max_score = models.FloatField(default=100.0)
    confidence = models.FloatField(
        validators=[MinValueValidator(0.0), MaxValueValidator(1.0)],
        default=0.8
    )
    
    # Content
    feedback = models.TextField()
    suggestions = models.JSONField(default=list, blank=True)
    
    # Position tracking for highlighting
    start_index = models.PositiveIntegerField(null=True, blank=True)
    end_index = models.PositiveIntegerField(null=True, blank=True)
    highlighted_text = models.TextField(blank=True)
    
    # AI details
    ai_model_version = models.CharField(max_length=50)
    processing_time_seconds = models.FloatField(null=True, blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'feedback'
        unique_together = ['essay', 'type']
        ordering = ['type__order']

class AIResponse(models.Model):
    """Raw AI responses for debugging and improvement"""
    essay = models.ForeignKey(Essay, on_delete=models.CASCADE, related_name='ai_responses')
    feedback_type = models.ForeignKey(FeedbackType, on_delete=models.CASCADE)
    
    # Raw response data
    prompt = models.TextField()
    response = models.JSONField()
    model_name = models.CharField(max_length=100)
    model_version = models.CharField(max_length=50)
    
    # Processing details
    tokens_used = models.PositiveIntegerField()
    processing_time_seconds = models.FloatField()
    cost_usd = models.DecimalField(max_digits=10, decimal_places=6)
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'ai_responses'
        ordering = ['-created_at']
```

### Analytics Models

#### Usage Analytics
```python
# analytics/models.py
from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()

class MetricType(models.Model):
    """Types of metrics collected"""
    name = models.CharField(max_length=50, unique=True)
    description = models.TextField()
    unit = models.CharField(max_length=20, help_text="Unit of measurement")
    
    class Meta:
        db_table = 'metric_types'

class Analytics(models.Model):
    """User analytics and system metrics"""
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='analytics')
    metric_type = models.ForeignKey(MetricType, on_delete=models.CASCADE)
    value = models.FloatField()
    
    # Context
    essay = models.ForeignKey('essay_submission.Essay', on_delete=models.CASCADE, null=True, blank=True)
    session_id = models.CharField(max_length=100, blank=True)
    
    # Metadata
    metadata = models.JSONField(default=dict, blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'analytics'
        verbose_name_plural = 'analytics'
        indexes = [
            models.Index(fields=['user', 'metric_type', 'created_at']),
            models.Index(fields=['metric_type', 'created_at']),
        ]

class Report(models.Model):
    """Generated reports for educators"""
    
    class ReportType(models.TextChoices):
        STUDENT_PROGRESS = 'student_progress', 'Student Progress'
        CLASS_PERFORMANCE = 'class_performance', 'Class Performance'
        SYSTEM_USAGE = 'system_usage', 'System Usage'
    
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='reports')
    report_type = models.CharField(max_length=50, choices=ReportType.choices)
    title = models.CharField(max_length=200)
    
    # Report content
    data = models.JSONField()
    summary = models.TextField()
    
    # Settings
    is_public = models.BooleanField(default=False)
    expires_at = models.DateTimeField(null=True, blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'reports'
        ordering = ['-created_at']
```

## 🔄 Model Relationships

### Relationship Diagram
```
User (1) ----< (Many) Essay
User (1) ----< (Many) Analytics
User (1) ----< (Many) Report

Essay (1) ----< (Many) EssayVersion
Essay (Many) >---- (1) Category
Essay (1) ----< (Many) Feedback
Essay (1) ----< (Many) AIResponse

Feedback (Many) >---- (1) FeedbackType
AIResponse (Many) >---- (1) FeedbackType
Analytics (Many) >---- (1) MetricType
```

## 🎯 Model Best Practices

### Performance Optimizations
```python
# Use select_related for foreign keys
essays = Essay.objects.select_related('user', 'category')

# Use prefetch_related for reverse foreign keys
users = User.objects.prefetch_related('essays__feedback')

# Use only() for specific fields
essays = Essay.objects.only('id', 'title', 'status')

# Use values() for aggregations
essay_stats = Essay.objects.values('status').annotate(count=Count('id'))
```

### Data Validation
```python
# Custom model validation
class Essay(models.Model):
    def clean(self):
        if self.word_count < 50:
            raise ValidationError('Essay must be at least 50 words')
        if self.word_count > 5000:
            raise ValidationError('Essay cannot exceed 5000 words')
    
    def save(self, *args, **kwargs):
        self.full_clean()
        super().save(*args, **kwargs)
```

### Query Optimization
```python
# Add database indexes for common queries
class Meta:
    indexes = [
        models.Index(fields=['user', 'status']),
        models.Index(fields=['created_at', 'status']),
        models.Index(fields=['category', 'created_at']),
    ]

# Use database constraints
class Meta:
    constraints = [
        models.UniqueConstraint(
            fields=['user', 'title'],
            name='unique_user_essay_title'
        ),
        models.CheckConstraint(
            check=models.Q(word_count__gte=50),
            name='essay_min_word_count'
        ),
    ]
```