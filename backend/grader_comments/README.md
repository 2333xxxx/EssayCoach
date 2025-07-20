# Grader Comments App Documentation

## Overview

The Grader Comments app provides a comprehensive system for human graders to add detailed feedback, annotations, and evaluations to student essays. It supports collaborative grading workflows and rich feedback mechanisms to complement AI-generated insights with expert human guidance.

## Features

### Feedback System
- **Rich Comments**: Detailed text feedback with formatting support
- **Inline Annotations**: Comments at specific text locations
- **Category Organization**: Organize feedback by type and importance
- **Reusable Templates**: Save and reuse common feedback patterns
- **Collaborative Grading**: Multiple graders can contribute

### Annotation Tools
- **Text Highlighting**: Mark important passages
- **Visual Feedback**: Drawing and markup tools
- **Multimedia Support**: Audio and video feedback options
- **Multi-page Support**: Handle long documents effectively

### Grading Workflow
- **Rubric-based Evaluation**: Consistent grading criteria
- **Quality Assurance**: Review and approval processes
- **Progress Tracking**: Monitor grading completion
- **Assignment Management**: Distribute essays to graders

## Models

### GraderComment
Core feedback model:
- `essay_id`: Foreign key to EssaySubmission
- `content`: Comment text
- `category`: Feedback category
- `position`: Location in essay
- `severity`: Importance level

### Annotation
Visual feedback model:
- `essay_id`: Foreign key to EssaySubmission
- `type`: Annotation type
- `position`: Location data
- `content`: Annotation content

### RubricScore
Grading evaluation model:
- `essay_id`: Foreign key to EssaySubmission
- `criteria`: Evaluation criteria
- `score`: Assigned score
- `comments`: Overall feedback

## API Endpoints

### Comments
```
POST /grader-comments/comments/     # Add comment
GET  /grader-comments/comments/     # List comments
PUT  /grader-comments/comments/{id}/ # Update comment
```

### Grading
```
POST /grader-comments/rubric-score/ # Submit scores
GET  /grader-comments/assignments/  # List assignments
```

## Configuration

### Settings Required
```python
INSTALLED_APPS = [
    # ... other apps
    'grader_comments',
]

GRADING_CONFIG = {
    'ENABLE_COLLABORATION': True,
    'MAX_GRADERS': 3,
}
```

## Testing
```bash
python manage.py test grader_comments
```

## Security Considerations
- Grader access control
- Student privacy protection
- Content moderation
- Audit trails

## Development
Focus on educational effectiveness and grader efficiency while maintaining flexibility for evolving grading methodologies.
