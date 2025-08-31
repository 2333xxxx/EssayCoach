# REST API Endpoints (MVP)

All endpoints are prefixed with `/api/v1` and use JSON for request and response bodies.  Authentication is handled via a JWT token supplied in the `Authorization: Bearer <token>` header.  Unless noted otherwise, responses follow the structure:

```json
{
  "success": true,
  "data": { }
}
```

Error responses return `success: false` with an `error` object describing the issue.

---

## Authentication

### POST /api/v1/auth/login
Authenticate a user and return access and refresh tokens.

**Request**

```json
{
  "email": "user@example.com",
  "password": "securePassword"
}
```

**Response** `201 Created`

```json
{
  "success": true,
  "data": {
    "access": "...",
    "refresh": "...",
  }
}
```

**Error Responses**

When credentials are invalid:
**Response** `401 Unauthorized`

```json
{
  "success": false,
  "error": {
    "code": "INVALID_CREDENTIALS",
    "message": "Invalid email or password"
  }
}
```

When account is suspended:
**Response** `423 Locked`

```json
{
  "success": false,
  "error": {
    "code": "ACCOUNT_LOCKED",
    "message": "Account is locked due to multiple failed attempts. Try again later."
  }
}
```

When input is invalid:
**Response** `400 Bad Request`

```json
{
  "success": false,
  "error": {
    "code": "INVALID_INPUT",
    "message": "Invalid email format or missing password"
  }
}
```

When server error occurs:
**Response** `500 Internal Server Error`

```json
{
  "success": false,
  "error": {
    "code": "SERVER_ERROR",
    "message": "Internal server error. Please try again later."
  }
}
```

### POST /api/v1/auth/register
Register a new user and return access and refresh tokens.

**Request**

```json
{
  "email": "user@example.com",
  "password": "securePassword",
}
```

**Response** `201 Created`

```json
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "access": "...",
    "refresh": "...",
  }
}
```
When email is already taken:
**Response** `409 Conflict`

```json
{
  "success": false,
  "error": {
    "code": "EMAIL_TAKEN",
    "message": "Email is already registered"
  }
}
```

When email is non-existent:
**Response** `404 Not Found`

```json
{
  "success": false,
  "error": {
    "code": "EMAIL_NOT_FOUND",
    "message": "Email is not registered"
  }
}
```

### POST /api/v1/auth/refresh
Exchange a refresh token for a new access token.

**Request**

```json
{
  "refresh": "..."
}
```

**Response** `200 OK`

```json
{
  "success": true,
  "data": {"access": "..."}
}
```

---

## Users

### GET /api/v1/users/info
Retrieve the current user's profile.

**Response** `200 OK`

```json
{
  "success": true,
  "data": {
    "id": 1,
    "email": "user@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "role": "student"
  }
}
```

### PATCH /api/v1/users/info
Update selected profile fields for the current user.

**Request**

```json
{
  "firstName": "Jane",
  "lastName": "Smith"
}
```

**Response** `200 OK`

```json
{
  "success": true,
  "data": {
    "id": 1,
    "firstName": "Jane",
    "lastName": "Smith"
  }
}
```

---

## Tasks

### GET /api/v1/tasks
Return tasks relevant to the authenticated user. Teachers see their created tasks; students see assigned tasks.

### POST /api/v1/tasks
Create a new task (teacher only).

**Request**

```json
{
  "unitId": "ENG101",
  "rubricId": 3,
  "title": "Argumentative Essay",
  "dueAt": "2024-07-01T12:00:00Z"
}
```

**Response** `201 Created`

```json
{
  "success": true,
  "data": {"taskId": 10}
}
```

### GET /api/v1/tasks/{taskId}
Retrieve details for a single task.

### PATCH /api/v1/tasks/{taskId}
Modify task attributes such as due date or rubric.

---

## Submissions

### POST /api/v1/tasks/{taskId}/submissions
Create or replace the authenticated student's submission for the task.

**Request**

```json
{
  "content": "Full essay text..."
}
```

**Response** `201 Created`

```json
{
  "success": true,
  "data": {"submissionId": 42}
}
```

### GET /api/v1/tasks/{taskId}/submissions/{submissionId}
Retrieve a specific submission. Teachers can access any submission for their tasks; students can access their own.

### PATCH /api/v1/tasks/{taskId}/submissions/{submissionId}
Update submission content if revisions are allowed.

---

## Rubrics

### GET /api/v1/rubrics
List rubrics accessible to the user.

### POST /api/v1/rubrics
Create a rubric composed of multiple rubric items.

### GET /api/v1/rubrics/{rubricId}
Retrieve rubric details including items and level descriptions.

### GET /api/v1/tasks/{taskId}/rubric
Fetch the rubric associated with a task.

---

## Feedback

### GET /api/v1/submissions/{submissionId}/feedback
Return AI and human feedback for a submission.

### POST /api/v1/submissions/{submissionId}/feedback
Add or update coach feedback for the submission.

**Request**

```json
{
  "items": [
    {
      "rubricItemId": 5,
      "score": 8,
      "comment": "Strong thesis statement"
    }
  ]
}
```

---

## Instant Feedback

### POST /api/v1/instant-feedback
Provide immediate AI evaluation for ad‑hoc writing practice. Each request includes the text and an optional rubric.

**Request**

```json
{
  "content": "Draft paragraph...",
  "rubricId": 3
}
```

**Response** `200 OK`

```json
{
  "success": true,
  "data": {
    "overallScore": 85,
    "comments": [
      {
        "type": "grammar",
        "message": "Consider revising sentence 2"
      }
    ]
  }
}
```

---

## Standard Status Codes

- `200 OK` – Successful request
- `201 Created` – Resource created
- `204 No Content` – Successful request with no response body
- `400 Bad Request` – Invalid input
- `401 Unauthorized` – Authentication required or failed
- `403 Forbidden` – Authenticated but not permitted
- `404 Not Found` – Resource does not exist
- `500 Internal Server Error` – Unexpected server error

