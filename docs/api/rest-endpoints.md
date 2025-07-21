# REST API Endpoints

## Authentication Endpoints

### POST /api/auth/login
Authenticate user and return JWT token.

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "securepassword"
}
```

**Response:**
```json
{
  "access": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "refresh": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "first_name": "John",
    "last_name": "Doe"
  }
}
```

### POST /api/auth/refresh
Refresh JWT access token using refresh token.

**Request Body:**
```json
{
  "refresh": "eyJ0eXAiOiJKV1QiLCJhbGc..."
}
```

**Response:**
```json
{
  "access": "eyJ0eXAiOiJKV1QiLCJhbGc..."
}
```

## Essay Management

### GET /api/essays/
Retrieve list of essays for the authenticated user.

**Query Parameters:**
- `status` (optional): Filter by status (draft, submitted, graded)
- `limit` (optional): Number of results to return (default: 20)
- `offset` (optional): Number of results to skip (default: 0)

**Response:**
```json
{
  "count": 25,
  "next": "/api/essays/?limit=20&offset=20",
  "previous": null,
  "results": [
    {
      "id": 1,
      "title": "My Essay Title",
      "status": "draft",
      "created_at": "2024-01-15T10:30:00Z",
      "updated_at": "2024-01-15T14:45:00Z"
    }
  ]
}
```

### POST /api/essays/
Create a new essay.

**Request Body:**
```json
{
  "title": "My New Essay",
  "prompt": "Essay prompt or question",
  "content": "Initial essay content..."
}
```

**Response:**
```json
{
  "id": 2,
  "title": "My New Essay",
  "prompt": "Essay prompt or question",
  "content": "Initial essay content...",
  "status": "draft",
  "created_at": "2024-01-15T15:00:00Z",
  "updated_at": "2024-01-15T15:00:00Z"
}
```

### GET /api/essays/{id}/
Retrieve detailed information about a specific essay.

**Response:**
```json
{
  "id": 1,
  "title": "My Essay Title",
  "prompt": "Essay prompt or question",
  "content": "Full essay content...",
  "status": "draft",
  "word_count": 1250,
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-01-15T14:45:00Z",
  "feedback": [
    {
      "id": 1,
      "type": "grammar",
      "comment": "Consider rephrasing this sentence for clarity",
      "highlight_start": 156,
      "highlight_end": 189,
      "created_at": "2024-01-15T11:00:00Z"
    }
  ]
}
```

### PUT /api/essays/{id}/
Update an existing essay.

**Request Body:**
```json
{
  "title": "Updated Essay Title",
  "content": "Updated essay content..."
}
```

### DELETE /api/essays/{id}/
Delete an essay (soft delete).

## Feedback Management

### GET /api/feedback/
Retrieve feedback for user's essays.

**Query Parameters:**
- `essay_id` (optional): Filter feedback for specific essay
- `type` (optional): Filter by feedback type (grammar, structure, content)

### POST /api/feedback/
Submit feedback for an essay (for coaches).

**Request Body:**
```json
{
  "essay": 1,
  "type": "grammar",
  "comment": "Great use of transitional phrases in this paragraph",
  "highlight_start": 200,
  "highlight_end": 250
}
```

## User Management

### GET /api/users/profile/
Retrieve current user's profile information.

**Response:**
```json
{
  "id": 1,
  "email": "user@example.com",
  "first_name": "John",
  "last_name": "Doe",
  "role": "student",
  "subscription_type": "premium",
  "created_at": "2024-01-01T00:00:00Z"
}
```

### PUT /api/users/profile/
Update user profile information.

**Request Body:**
```json
{
  "first_name": "Jane",
  "last_name": "Smith"
}
```