# WebSocket Events

## Connection

### Connection Establishment
WebSocket connections are established at: `ws://localhost:8000/ws/essays/{essay_id}/`

### Authentication
WebSocket connections require JWT token authentication via query parameter:
`ws://localhost:8000/ws/essays/1/?token=eyJ0eXAiOiJKV1QiLCJhbGc...`

## Real-time Events

### Essay Updates
**Event:** `essay_update`

**Description:** Sent when an essay's content is updated by any connected client.

**Payload:**
```json
{
  "type": "essay_update",
  "essay_id": 1,
  "content": "Updated essay content...",
  "word_count": 1280,
  "updated_by": {
    "id": 2,
    "name": "Jane Smith",
    "role": "coach"
  },
  "timestamp": "2024-01-15T15:30:00Z"
}
```

### New Feedback
**Event:** `new_feedback`

**Description:** Sent when new feedback is added to an essay.

**Payload:**
```json
{
  "type": "new_feedback",
  "essay_id": 1,
  "feedback": {
    "id": 3,
    "type": "content",
    "comment": "This paragraph could benefit from more specific examples",
    "highlight_start": 450,
    "highlight_end": 520,
    "author": {
      "id": 3,
      "name": "Dr. Sarah Johnson",
      "role": "coach"
    },
    "created_at": "2024-01-15T16:00:00Z"
  }
}
```

### Feedback Update
**Event:** `feedback_update`

**Description:** Sent when existing feedback is modified.

**Payload:**
```json
{
  "type": "feedback_update",
  "essay_id": 1,
  "feedback": {
    "id": 2,
    "type": "grammar",
    "comment": "Updated comment with better explanation",
    "highlight_start": 156,
    "highlight_end": 189,
    "updated_at": "2024-01-15T16:15:00Z"
  }
}
```

### User Presence
**Event:** `user_joined`

**Description:** Sent when a user joins the essay editing session.

**Payload:**
```json
{
  "type": "user_joined",
  "essay_id": 1,
  "user": {
    "id": 4,
    "name": "Mike Wilson",
    "role": "student",
    "avatar_url": "/media/avatars/mike.jpg"
  },
  "timestamp": "2024-01-15T16:30:00Z"
}
```

**Event:** `user_left`

**Description:** Sent when a user leaves the essay editing session.

**Payload:**
```json
{
  "type": "user_left",
  "essay_id": 1,
  "user_id": 4,
  "timestamp": "2024-01-15T16:45:00Z"
}
```

### Typing Indicators
**Event:** `typing_start`

**Description:** Sent when a user starts typing in the essay editor.

**Payload:**
```json
{
  "type": "typing_start",
  "essay_id": 1,
  "user": {
    "id": 2,
    "name": "Jane Smith",
    "role": "coach"
  },
  "timestamp": "2024-01-15T16:20:00Z"
}
```

**Event:** `typing_stop`

**Description:** Sent when a user stops typing in the essay editor.

**Payload:**
```json
{
  "type": "typing_stop",
  "essay_id": 1,
  "user_id": 2,
  "timestamp": "2024-01-15T16:21:00Z"
}
```

## Client-to-Server Events

### Subscribe to Essay
**Event:** `subscribe_essay`

**Description:** Subscribe to real-time updates for a specific essay.

**Payload:**
```json
{
  "action": "subscribe_essay",
  "essay_id": 1
}
```

### Update Essay Content
**Event:** `update_essay`

**Description:** Send essay content updates to the server.

**Payload:**
```json
{
  "action": "update_essay",
  "essay_id": 1,
  "content": "Updated essay content...",
  "cursor_position": 1250
}
```

### Add Feedback
**Event:** `add_feedback`

**Description:** Add new feedback to an essay.

**Payload:**
```json
{
  "action": "add_feedback",
  "essay_id": 1,
  "feedback": {
    "type": "structure",
    "comment": "Consider adding a stronger thesis statement",
    "highlight_start": 0,
    "highlight_end": 150
  }
}
```

## Error Handling

### Connection Errors
**Event:** `connection_error`

**Payload:**
```json
{
  "type": "connection_error",
  "error": "authentication_failed",
  "message": "Invalid or expired token"
}
```

### Permission Errors
**Event:** `permission_denied`

**Payload:**
```json
{
  "type": "permission_denied",
  "error": "insufficient_permissions",
  "message": "You don't have permission to edit this essay"
}
```