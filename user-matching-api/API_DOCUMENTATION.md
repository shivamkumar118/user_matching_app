# User Matching API Documentation

## Base URL
```
http://localhost:3000/api/v1
```

## Authentication
All API requests (except login/register) require a JWT token in the Authorization header:
```
Authorization: Bearer <your_jwt_token>
```

---

## Authentication Endpoints

### 1. Register User
**POST** `/auth/register`

**Request Body:**
```json
{
  "user": {
    "email": "newuser@example.com",
    "password": "password123",
    "password_confirmation": "password123",
    "first_name": "John",
    "last_name": "Doe",
    "phone": "+1-555-0101",
    "address": "123 Main St, New York, NY",
    "bio": "Passionate software engineer",
    "employment_status": "employed",
    "about": "I love building scalable applications"
  }
}
```

**Response:**
```json
{
  "status": "success",
  "message": "User registered successfully",
  "data": {
    "user": { ... },
    "token": "eyJhbGciOiJIUzI1NiJ9..."
  }
}
```

### 2. Login User
**POST** `/auth/login`

**Request Body:**
```json
{
  "email": "john.doe@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "status": "success",
  "message": "Login successful",
  "data": {
    "user": { ... },
    "token": "eyJhbGciOiJIUzI1NiJ9..."
  }
}
```

### 3. Logout User
**POST** `/auth/logout`

**Headers:** `Authorization: Bearer <token>`

---

## User Endpoints

### 1. List All Users
**GET** `/users`

**Headers:** `Authorization: Bearer <token>`

**Query Parameters:**
- `page` (optional): Page number for pagination
- `per_page` (optional): Items per page (default: 20)

### 2. Get User Profile
**GET** `/users/:id`

**Headers:** `Authorization: Bearer <token>`

### 3. Update User Profile
**PUT** `/users/:id`

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "user": {
    "first_name": "John",
    "last_name": "Doe",
    "phone": "+1-555-0101",
    "address": "123 Main St, New York, NY",
    "bio": "Updated bio",
    "employment_status": "employed",
    "about": "Updated about section"
  }
}
```

### 4. Get User Profile with Details
**GET** `/users/:id/profile`

**Headers:** `Authorization: Bearer <token>`

---

## Questions Endpoints

### 1. List All Questions
**GET** `/questions`

**Headers:** `Authorization: Bearer <token>`

**Query Parameters:**
- `category` (optional): Filter by category

### 2. Get Question Details
**GET** `/questions/:id`

**Headers:** `Authorization: Bearer <token>`

---

## Answers Endpoints

### 1. List User Answers
**GET** `/users/:user_id/answers`

**Headers:** `Authorization: Bearer <token>`

**Query Parameters:**
- `question_id` (optional): Filter by question

### 2. Create Answer
**POST** `/users/:user_id/answers`

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "answer": {
    "question_id": 1,
    "answer_text": "I prefer a hybrid work environment with 2-3 days in the office."
  }
}
```

### 3. Update Answer
**PUT** `/users/:user_id/answers/:id`

**Headers:** `Authorization: Bearer <token>`

### 4. Delete Answer
**DELETE** `/users/:user_id/answers/:id`

**Headers:** `Authorization: Bearer <token>`

---

## Skills Endpoints

### 1. List User Skills
**GET** `/users/:user_id/skills`

**Headers:** `Authorization: Bearer <token>`

**Query Parameters:**
- `category` (optional): Filter by category

### 2. Create Skill
**POST** `/users/:user_id/skills`

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "skill": {
    "value": "Ruby on Rails",
    "category": "frameworks",
    "rating": 5
  }
}
```

### 3. Update Skill
**PUT** `/users/:user_id/skills/:id`

**Headers:** `Authorization: Bearer <token>`

### 4. Delete Skill
**DELETE** `/users/:user_id/skills/:id`

**Headers:** `Authorization: Bearer <token>`

---

## Experiences Endpoints

### 1. List User Experiences
**GET** `/users/:user_id/experiences`

**Headers:** `Authorization: Bearer <token>`

**Query Parameters:**
- `current` (optional): Filter current/past experiences (true/false)

### 2. Create Experience
**POST** `/users/:user_id/experiences`

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "experience": {
    "job_title": "Senior Software Engineer",
    "company_name": "TechCorp",
    "start_date": "2020-03-01",
    "end_date": null,
    "description": "Leading development of microservices architecture."
  }
}
```

### 3. Update Experience
**PUT** `/users/:user_id/experiences/:id`

**Headers:** `Authorization: Bearer <token>`

### 4. Delete Experience
**DELETE** `/users/:user_id/experiences/:id`

**Headers:** `Authorization: Bearer <token>`

---

## Matching Endpoints

### 1. Get Users with Match Scores
**GET** `/matching/users`

**Headers:** `Authorization: Bearer <token>`

**Response:**
```json
{
  "status": "success",
  "message": "Users with match scores retrieved successfully",
  "data": {
    "users": [
      {
        "user": { ... },
        "match_score": 0.75,
        "match_percentage": 75.0
      }
    ],
    "current_user": { ... }
  }
}
```

### 2. Calculate Match Score
**GET** `/matching/calculate/:user_id`

**Headers:** `Authorization: Bearer <token>`

**Response:**
```json
{
  "status": "success",
  "message": "Match score calculated successfully",
  "data": {
    "user": { ... },
    "match_score": 0.75,
    "match_percentage": 75.0,
    "breakdown": {
      "answer_similarity": 0.8,
      "skill_similarity": 0.7,
      "experience_similarity": 0.6,
      "profile_completion_similarity": 0.9
    }
  }
}
```

### 3. Calculate Compatibility Between Two Users
**GET** `/matching/compatibility/:user_id/:other_user_id`

**Headers:** `Authorization: Bearer <token>`

---

## Sample Test Data

### Pre-loaded Users:
- **John Doe**: john.doe@example.com / password123
- **Jane Smith**: jane.smith@example.com / password123
- **Mike Johnson**: mike.johnson@example.com / password123
- **Sarah Wilson**: sarah.wilson@example.com / password123
- **Alex Chen**: alex.chen@example.com / password123

### Sample Questions:
- "What's your preferred work environment?"
- "How do you handle stress and pressure?"
- "What motivates you the most in your career?"
- And 7 more questions...

---

## Testing with cURL

### 1. Register a new user:
```bash
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "user": {
      "email": "test@example.com",
      "password": "password123",
      "password_confirmation": "password123",
      "first_name": "Test",
      "last_name": "User"
    }
  }'
```

### 2. Login:
```bash
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john.doe@example.com",
    "password": "password123"
  }'
```

### 3. Get users with match scores (using token from login):
```bash
curl -X GET http://localhost:3000/api/v1/matching/users \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### 4. Get questions:
```bash
curl -X GET http://localhost:3000/api/v1/questions \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

---

## Error Responses

All endpoints return consistent error responses:

```json
{
  "status": "error",
  "message": "Error description",
  "errors": ["Detailed error messages"]
}
```

Common HTTP status codes:
- `200`: Success
- `201`: Created
- `400`: Bad Request
- `401`: Unauthorized
- `404`: Not Found
- `422`: Unprocessable Entity
- `500`: Internal Server Error 