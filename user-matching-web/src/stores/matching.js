import { defineStore } from 'pinia'
import { matchingAPI } from '@/services/api'

export const useMatchingStore = defineStore('matching', {
  state: () => ({
    users: [],
    filteredUsers: [],
    selectedUser: null,
    matchDetails: null,
    loading: false,
    error: null,
    searchQuery: '',
    activeFilter: 'all',
    filters: {
      all: 'All Users',
      highMatch: 'High Match (80%+)',
      mediumMatch: 'Medium Match (60-79%)',
      lowMatch: 'Low Match (<60%)'
    }
  }),

  getters: {
    // Get users sorted by match score (highest first)
    sortedUsers: (state) => {
      return [...state.users].sort((a, b) => b.match_score - a.match_score)
    },

    // Get filtered users based on search and filter
    getFilteredUsers: (state) => {
      let filtered = state.users

      // Apply search filter
      if (state.searchQuery.trim()) {
        const query = state.searchQuery.toLowerCase()
        filtered = filtered.filter(user => {
          const userData = user.user
          return (
            userData.first_name?.toLowerCase().includes(query) ||
            userData.last_name?.toLowerCase().includes(query) ||
            userData.email?.toLowerCase().includes(query) ||
            userData.address?.toLowerCase().includes(query) ||
            userData.bio?.toLowerCase().includes(query) ||
            userData.about?.toLowerCase().includes(query) ||
            userData.skills?.some(skill => skill.value?.toLowerCase().includes(query)) ||
            userData.experiences?.some(exp => 
              exp.job_title?.toLowerCase().includes(query) ||
              exp.company_name?.toLowerCase().includes(query)
            )
          )
        })
      }

      // Apply match score filter
      switch (state.activeFilter) {
        case 'highMatch':
          filtered = filtered.filter(user => user.match_percentage >= 80)
          break
        case 'mediumMatch':
          filtered = filtered.filter(user => user.match_percentage >= 60 && user.match_percentage < 80)
          break
        case 'lowMatch':
          filtered = filtered.filter(user => user.match_percentage < 60)
          break
        default:
          // 'all' - no additional filtering
          break
      }

      return filtered.sort((a, b) => b.match_score - a.match_score)
    },

    // Get match breakdown for selected user
    getMatchBreakdown: (state) => {
      if (!state.matchDetails?.breakdown) return null
      
      return [
        {
          name: 'Answer Similarity',
          value: state.matchDetails.breakdown.answer_similarity,
          percentage: Math.round(state.matchDetails.breakdown.answer_similarity * 100),
          icon: '💬',
          description: 'Similar responses to questions'
        },
        {
          name: 'Skill Similarity',
          value: state.matchDetails.breakdown.skill_similarity,
          percentage: Math.round(state.matchDetails.breakdown.skill_similarity * 100),
          icon: '🎯',
          description: 'Matching skills and expertise'
        },
        {
          name: 'Experience Similarity',
          value: state.matchDetails.breakdown.experience_similarity,
          percentage: Math.round(state.matchDetails.breakdown.experience_similarity * 100),
          icon: '🌟',
          description: 'Similar work experience'
        },
        {
          name: 'Profile Completion',
          value: state.matchDetails.breakdown.profile_completion_similarity,
          percentage: Math.round(state.matchDetails.breakdown.profile_completion_similarity * 100),
          icon: '📋',
          description: 'Profile completion similarity'
        }
      ]
    }
  },

  actions: {
    async fetchUsers(params = {}) {
      this.loading = true
      this.error = null
      try {
        const response = await matchingAPI.getUsers(params)
        this.users = response.data.data.users || []
        this.filteredUsers = this.users // Backend handles filtering
      } catch (error) {
        this.error = error.response?.data?.message || 'Failed to fetch users'
        console.error('Error fetching users:', error)
      } finally {
        this.loading = false
      }
    },

    async searchUsers(searchQuery) {
      this.searchQuery = searchQuery
      await this.fetchUsers({ search: searchQuery, filter: this.activeFilter })
    },

    async filterUsers(filter) {
      this.activeFilter = filter
      await this.fetchUsers({ search: this.searchQuery, filter: filter })
    },

    async clearFilters() {
      this.searchQuery = ''
      this.activeFilter = 'all'
      await this.fetchUsers()
    },

    async calculateMatch(userId) {
      this.loading = true
      this.error = null
      try {
        const response = await matchingAPI.calculateMatch(userId)
        this.matchDetails = response.data.data
        return response.data.data
      } catch (error) {
        this.error = error.response?.data?.message || 'Failed to calculate match'
        console.error('Error calculating match:', error)
        throw error
      } finally {
        this.loading = false
      }
    },

    async getCompatibility(userId1, userId2) {
      this.loading = true
      this.error = null
      try {
        const response = await matchingAPI.getCompatibility(userId1, userId2)
        this.matchDetails = response.data.data
        return response.data.data
      } catch (error) {
        this.error = error.response?.data?.message || 'Failed to get compatibility'
        console.error('Error getting compatibility:', error)
        throw error
      } finally {
        this.loading = false
      }
    },

    setSelectedUser(user) {
      this.selectedUser = user
    },

    clearSelectedUser() {
      this.selectedUser = null
    },

    clearMatchDetails() {
      this.matchDetails = null
    },

    clearAll() {
      this.selectedUser = null
      this.matchDetails = null
    },

    setSearchQuery(query) {
      this.searchQuery = query
      this.filteredUsers = this.getFilteredUsers
    },

    setActiveFilter(filter) {
      this.activeFilter = filter
      this.filteredUsers = this.getFilteredUsers
    },

    clearError() {
      this.error = null
    }
  }
}) 