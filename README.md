# User Matching Application

A sophisticated user matching platform that connects people based on their profiles, skills, experiences, and compatibility answers. Built with Ruby on Rails API and Vue.js frontend.

## 🚀 Features

### User Management
- JWT-based authentication and registration
- Comprehensive profile creation with personal information
- Profile completion tracking and validation

### Profile Building
- **Skills Management**: Add technical/professional skills with categories and ratings
- **Experience Tracking**: Complete job history with titles, companies, dates, and descriptions
- **Questionnaire System**: Answer compatibility questions for better matching

### Smart Matching Algorithm
The system calculates match scores using a weighted algorithm:
- **40%** - Answer similarity (questionnaire responses)
- **30%** - Skill similarity (common skills and categories)
- **20%** - Experience similarity (job titles and companies)
- **10%** - Profile completion similarity

### Discovery & Search
- Advanced search by name, skills, location, or experience
- Match filtering (High: 80%+, Medium: 60-79%, Low: <60%)
- Detailed compatibility breakdowns
- Real-time match score calculations

## 🛠️ Tech Stack

### Backend
- **Ruby on Rails** - RESTful API
- **PostgreSQL** - Database
- **JWT** - Authentication
- **Devise** - User management

### Frontend
- **Vue.js 3** - Frontend framework
- **Pinia** - State management
- **Vue Router** - Routing
- **Tailwind CSS** - Styling
- **Vite** - Build tool
