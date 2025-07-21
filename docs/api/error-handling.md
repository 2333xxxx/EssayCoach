# Error Handling

## Overview
EssayCoach uses consistent error handling across all API endpoints and WebSocket connections.

## HTTP Error Responses

### 400 Bad Request
```json
{
  "error": "validation_error",
  "message": "Invalid request data",
  "details": {
    "title": ["This field is required"],
    "content": ["Content must be at least 100 characters"]
  }
}
```

### 401 Unauthorized
```json
{
  "error": "authentication_required",
  "message": "Authentication credentials were not provided"
}
```

### 403 Forbidden
```json
{
  "error": "permission_denied",
  "message": "You do not have permission to perform this action"
}
```

### 404 Not Found
```json
{
  "error": "not_found",
  "message": "Essay with id 123 not found"
}
```

### 429 Too Many Requests
```json
{
  "error": "rate_limit_exceeded",
  "message": "Rate limit exceeded. Try again in 60 seconds"
}
```

### 500 Internal Server Error
```json
{
  "error": "server_error",
  "message": "An unexpected error occurred. Please try again later"
}
```

## WebSocket Error Events

### Authentication Errors
```json
{
  "type": "error",
  "error": "auth_failed",
  "message": "Invalid authentication token"
}
```

### Permission Errors
```json
{
  "type": "error",
  "error": "permission_denied",
  "message": "You don't have access to this essay"
}
```

### Validation Errors
```json
{
  "type": "error",
  "error": "validation_error",
  "message": "Invalid essay content"
}
```

## Error Codes Reference

| Code | Description |
|------|-------------|
| `validation_error` | Request data validation failed |
| `authentication_required` | Missing or invalid authentication |
| `permission_denied` | Insufficient permissions |
| `not_found` | Requested resource not found |
| `rate_limit_exceeded` | Too many requests |
| `server_error` | Internal server error |
| `conflict` | Resource conflict |
| `unprocessable_entity` | Request understood but cannot be processed |