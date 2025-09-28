import { defineStore } from 'pinia'
import { userAPI, skillsAPI, experiencesAPI, questionsAPI, answersAPI } from '@/services/api'

export const useUserStore = defineStore('user', {
  state: () => ({
    profile: null,
    skills: [],
    experiences: [],
    questions: [],
    answers: [],
    loading: false,
    error: null
  }),

  getters: {
    hasCompleteProfile: (state) => {
      return state.profile && state.profile.first_name && state.profile.last_name && state.profile.email
    },
    
    profileCompletionPercentage: (state) => {
      if (!state.profile) return 0
      
      const requiredFields = ['first_name', 'last_name', 'email']
      const optionalFields = ['phone', 'address', 'bio', 'employment_status', 'about']
      
      const completedRequired = requiredFields.filter(field => state.profile[field]).length
      const completedOptional = optionalFields.filter(field => state.profile[field]).length
      
      const totalFields = requiredFields.length + optionalFields.length
      const completedFields = completedRequired + completedOptional
      
      return Math.round((completedFields / totalFields) * 100)
    },
    
    currentExperiences: (state) => {
      return state.experiences.filter(exp => !exp.end_date || new Date(exp.end_date) > new Date())
    },
    
    pastExperiences: (state) => {
      return state.experiences.filter(exp => exp.end_date && new Date(exp.end_date) <= new Date())
    },
    
    skillsByCategory: (state) => {
      const grouped = {}
      state.skills.forEach(skill => {
        if (!grouped[skill.category]) {
          grouped[skill.category] = []
        }
        grouped[skill.category].push(skill)
      })
      return grouped
    },

    questionsWithAnswers: (state) => {
      console.log('Computing questionsWithAnswers:', { 
        questionsCount: state.questions.length, 
        answersCount: state.answers.length,
        questions: state.questions.map(q => ({ id: q.id, title: q.title })),
        answers: state.answers.map(a => ({ id: a.id, question_id: a.question_id, answer_text: a.answer_text }))
      })
      
      return state.questions
        .sort((a, b) => a.id - b.id) // Sort by ID to ensure Q1, Q2, Q3 order
        .map(question => {
          // Find answer by matching question_id for more reliable matching
          const answer = state.answers.find(ans => ans.question_id === question.id)
          
          const result = {
            ...question,
            answer: answer ? answer.answer_text : '',
            answered: !!answer,
            answer_id: answer ? answer.id : null
          }
          
          console.log(`Question ${question.id} (${question.title}):`, {
            hasAnswer: !!answer,
            answerText: answer ? answer.answer_text : 'none',
            answerId: answer ? answer.id : null
          })
          
          return result
        })
    },

    answeredQuestionsCount: (state) => {
      return state.answers.length
    },

    totalQuestionsCount: (state) => {
      return state.questions.length
    },

    questionsProgressPercentage: (state) => {
      if (state.questions.length === 0) return 0
      return Math.round((state.answers.length / state.questions.length) * 100)
    }
  },

  actions: {
    async fetchProfile() {
      this.loading = true
      this.error = null
      try {
        const response = await userAPI.getProfile()
        this.profile = response.data.data
        return response
      } catch (error) {
        this.error = error.response?.data?.message || 'Failed to fetch profile'
        throw error
      } finally {
        this.loading = false
      }
    },

    async updateProfile(userData) {
      this.loading = true
      this.error = null
      try {
        const response = await userAPI.updateProfile(userData)
        this.profile = response.data.data
        return response
      } catch (error) {
        this.error = error.response?.data?.message || 'Failed to update profile'
        throw error
      } finally {
        this.loading = false
      }
    },

    // Skills management
    async fetchSkills() {
      this.loading = true
      this.error = null
      try {
        const response = await skillsAPI.getSkills()
        this.skills = response.data.data
        return response
      } catch (error) {
        this.error = error.response?.data?.message || 'Failed to fetch skills'
        throw error
      } finally {
        this.loading = false
      }
    },

    async createSkill(skillData) {
      this.loading = true
      this.error = null
      try {
        const response = await skillsAPI.createSkill(skillData)
        this.skills.push(response.data.data)
        return response
      } catch (error) {
        this.error = error.response?.data?.message || 'Failed to create skill'
        throw error
      } finally {
        this.loading = false
      }
    },

    async updateSkill(id, skillData) {
      this.loading = true
      this.error = null
      try {
        const response = await skillsAPI.updateSkill(id, skillData)
        const index = this.skills.findIndex(skill => skill.id === id)
        if (index !== -1) {
          this.skills[index] = response.data.data
        }
        return response
      } catch (error) {
        this.error = error.response?.data?.message || 'Failed to update skill'
        throw error
      } finally {
        this.loading = false
      }
    },

    async deleteSkill(id) {
      this.loading = true
      this.error = null
      try {
        await skillsAPI.deleteSkill(id)
        this.skills = this.skills.filter(skill => skill.id !== id)
      } catch (error) {
        this.error = error.response?.data?.message || 'Failed to delete skill'
        throw error
      } finally {
        this.loading = false
      }
    },

    // Experiences management
    async fetchExperiences() {
      this.loading = true
      this.error = null
      try {
        const response = await experiencesAPI.getExperiences()
        this.experiences = response.data.data
        return response
      } catch (error) {
        this.error = error.response?.data?.message || 'Failed to fetch experiences'
        throw error
      } finally {
        this.loading = false
      }
    },

    async createExperience(experienceData) {
      this.loading = true
      this.error = null
      try {
        const response = await experiencesAPI.createExperience(experienceData)
        this.experiences.push(response.data.data)
        return response
      } catch (error) {
        this.error = error.response?.data?.message || 'Failed to create experience'
        throw error
      } finally {
        this.loading = false
      }
    },

    async updateExperience(id, experienceData) {
      this.loading = true
      this.error = null
      try {
        const response = await experiencesAPI.updateExperience(id, experienceData)
        const index = this.experiences.findIndex(exp => exp.id === id)
        if (index !== -1) {
          this.experiences[index] = response.data.data
        }
        return response
      } catch (error) {
        this.error = error.response?.data?.message || 'Failed to update experience'
        throw error
      } finally {
        this.loading = false
      }
    },

    async deleteExperience(id) {
      this.loading = true
      this.error = null
      try {
        await experiencesAPI.deleteExperience(id)
        this.experiences = this.experiences.filter(exp => exp.id !== id)
      } catch (error) {
        this.error = error.response?.data?.message || 'Failed to delete experience'
        throw error
      } finally {
        this.loading = false
      }
    },

    clearError() {
      this.error = null
    },

    // Questions management
    async fetchQuestions() {
      this.loading = true
      this.error = null
      try {
        const response = await questionsAPI.getQuestions()
        this.questions = response.data.data
        return response
      } catch (error) {
        this.error = error.response?.data?.message || 'Failed to fetch questions'
        throw error
      } finally {
        this.loading = false
      }
    },

    // Answers management
    async fetchAnswers() {
      this.loading = true
      this.error = null
      try {
        const response = await answersAPI.getAnswers()
        this.answers = response.data.data
        console.log('Fetched answers:', this.answers) // Debug log
        return response
      } catch (error) {
        this.error = error.response?.data?.message || 'Failed to fetch answers'
        throw error
      } finally {
        this.loading = false
      }
    },

    async createAnswer(answerData) {
      this.loading = true
      this.error = null
      try {
        const response = await answersAPI.createAnswer(answerData)
        const newAnswer = response.data.data
        this.answers.push(newAnswer)
        console.log('Created answer:', newAnswer) // Debug log
        return response
      } catch (error) {
        // Handle validation errors more specifically
        if (error.response?.data?.errors) {
          this.error = error.response.data.errors.join(', ')
        } else {
          this.error = error.response?.data?.message || 'Failed to create answer'
        }
        throw error
      } finally {
        this.loading = false
      }
    },

    async updateAnswer(id, answerData) {
      this.loading = true
      this.error = null
      try {
        const response = await answersAPI.updateAnswer(id, answerData)
        const updatedAnswer = response.data.data
        const index = this.answers.findIndex(answer => answer.id === id)
        if (index !== -1) {
          this.answers[index] = updatedAnswer
        } else {
          // If not found, add it (this shouldn't happen but just in case)
          this.answers.push(updatedAnswer)
        }
        console.log('Updated answer:', updatedAnswer) // Debug log
        return response
      } catch (error) {
        // Handle validation errors more specifically
        if (error.response?.data?.errors) {
          this.error = error.response.data.errors.join(', ')
        } else {
          this.error = error.response?.data?.message || 'Failed to update answer'
        }
        throw error
      } finally {
        this.loading = false
      }
    },

    async deleteAnswer(id) {
      this.loading = true
      this.error = null
      try {
        await answersAPI.deleteAnswer(id)
        this.answers = this.answers.filter(answer => answer.id !== id)
      } catch (error) {
        this.error = error.response?.data?.message || 'Failed to delete answer'
        throw error
      } finally {
        this.loading = false
      }
    },

    // Load all questions and answers data
    async loadQuestionsData() {
      this.loading = true
      this.error = null
      try {
        console.log('Loading questions and answers data...') // Debug log
        await Promise.all([
          this.fetchQuestions(),
          this.fetchAnswers()
        ])
        console.log('Questions and answers loaded successfully') // Debug log
      } catch (error) {
        this.error = error.response?.data?.message || 'Failed to load questions data'
        throw error
      } finally {
        this.loading = false
      }
    },

    // Dashboard statistics
    async getTotalUsersCount() {
      this.loading = true
      this.error = null
      try {
        const response = await userAPI.getUsers()
        return response.data.data.length
      } catch (error) {
        this.error = error.response?.data?.message || 'Failed to fetch users count'
        throw error
      } finally {
        this.loading = false
      }
    },

    async getUserMatches() {
      this.loading = true
      this.error = null
      try {
        const response = await matchingAPI.getUsers()
        // Return the average match percentage of top 5 matches
        const topMatches = response.data.data.users.slice(0, 5)
        if (topMatches.length === 0) return 0
        
        const averageMatch = topMatches.reduce((sum, match) => sum + match.match_percentage, 0) / topMatches.length
        return Math.round(averageMatch)
      } catch (error) {
        this.error = error.response?.data?.message || 'Failed to fetch user matches'
        throw error
      } finally {
        this.loading = false
      }
    }
  }
}) 