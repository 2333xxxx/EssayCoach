# Notification App Documentation

## Overview

The Notification app manages all user notifications and alerts across the EssayCoach platform. It provides a comprehensive notification system supporting multiple channels and personalized preferences to keep users informed about important events and updates.

## Features

### Multi-Channel Delivery
- **Email Notifications**: Rich HTML email alerts
- **In-App Notifications**: Real-time notifications within the platform
- **Push Notifications**: Browser and mobile push alerts
- **SMS Support**: Text message alerts for critical events
- **Digest Options**: Daily/weekly summary emails

### Notification Types
- **Essay Updates**: Status changes and feedback availability
- **Deadline Reminders**: Assignment and submission alerts
- **Grading Notifications**: When human feedback is ready
- **System Alerts**: Platform updates and maintenance
- **User Communications**: Direct messages and announcements

### Personalization
- **User Preferences**: Granular notification settings
- **Channel Selection**: Choose preferred delivery methods
- **Frequency Control**: Control notification timing
- **Quiet Hours**: Do-not-disturb periods
- **Language Support**: Multi-language notifications

## Models

### Notification
Core notification model:
- `user_id`: Recipient user
- `type`: Notification category
- `title`: Notification title
- `message`: Notification content
- `status`: Delivery status
- `channels`: Delivery methods

### NotificationPreference
User settings:
- `user_id`: User preferences
- `channel`: Delivery channel
- `enabled`: On/off toggle
- `frequency`: Timing preferences

## API Endpoints

### Notifications
```
GET  /notifications/                # List notifications
POST /notifications/                # Create notification
PUT  /notifications/{id}/read/      # Mark as read
```

### Preferences
```
GET  /notifications/preferences/    # Get preferences
PUT  /notifications/preferences/    # Update preferences
```

## Configuration

### Settings Required
```python
INSTALLED_APPS = [
    # ... other apps
    'notification',
]

NOTIFICATION_CONFIG = {
    'ENABLE_EMAIL': True,
    'ENABLE_PUSH': True,
    'BATCH_SIZE': 100,
}
```

## Testing
```bash
python manage.py test notification
```

## Security Considerations
- Rate limiting to prevent spam
- User privacy protection
- Secure message delivery
- Access control for notifications

## Development
Focus on timely, relevant notifications while maintaining user control and privacy.
