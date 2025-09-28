import axios from 'axios'

// Create axios instance with base configuration
const api = axios.create({
  baseURL: 'http://localhost:3000/api/v1',
  headers: {
    'Content-Type': 'application/json',
  },
})

// Request interceptor to add JWT token
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('authToken')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

// Response interceptor to handle authentication errors
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      localStorage.removeItem('authToken')
      window.location.href = '/login'
    }
    return Promise.reject(error)
  }
)

// Auth API
export const authAPI = {
  register: (userData) => api.post('/auth/register', { user: userData }),
  login: (credentials) => api.post('/auth/login', credentials),
  logout: () => api.post('/auth/logout'),
}

// User API
export const userAPI = {
  getProfile: () => api.get('/users/profile'),
  updateProfile: (userData) => api.put('/users/profile', userData),
  getUsers: () => api.get('/users'),
  getUser: (id) => api.get(`/users/${id}`),
  getMatches: () => api.get('/users/matches'),
}

// Questions API
export const questionsAPI = {
  getQuestions: () => api.get('/questions'),
  getQuestion: (id) => api.get(`/questions/${id}`),
}

// Answers API
export const answersAPI = {
  getAnswers: () => api.get('/answers'),
  createAnswer: (answerData) => api.post('/answers', answerData),
  updateAnswer: (id, answerData) => api.put(`/answers/${id}`, answerData),
  deleteAnswer: (id) => api.delete(`/answers/${id}`),
}

// Skills API
export const skillsAPI = {
  getSkills: () => api.get('/skills'),
  createSkill: (skillData) => api.post('/skills', skillData),
  updateSkill: (id, skillData) => api.put(`/skills/${id}`, skillData),
  deleteSkill: (id) => api.delete(`/skills/${id}`),
}

// Experiences API
export const experiencesAPI = {
  getExperiences: () => api.get('/experiences'),
  createExperience: (experienceData) => api.post('/experiences', experienceData),
  updateExperience: (id, experienceData) => api.put(`/experiences/${id}`, experienceData),
  deleteExperience: (id) => api.delete(`/experiences/${id}`),
}

// Matching API
export const matchingAPI = {
  getUsers: (params = {}) => {
    const queryParams = new URLSearchParams()
    if (params.search) queryParams.append('search', params.search)
    if (params.filter) queryParams.append('filter', params.filter)
    
    const url = queryParams.toString() ? `/matching/users?${queryParams.toString()}` : '/matching/users'
    return api.get(url)
  },
  calculateMatch: (userId) => api.get(`/matching/calculate/${userId}`),
  getCompatibility: (userId1, userId2) => api.get(`/matching/compatibility/${userId1}/${userId2}`),
}

export default api 