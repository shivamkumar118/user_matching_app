<template>
  <BaseLayout>
    <div class="matching-container">
      <!-- Header -->
      <div class="matching-header">
        <h1 class="matching-title">Find Matches</h1>
        <p class="matching-subtitle">Discover people with similar interests and skills</p>
      </div>

      <!-- Search and Filters -->
      <div class="search-section">
        <div class="search-card">
          <div class="search-input-group">
            <input 
              v-model="matchingStore.searchQuery"
              @input="handleSearch"
              type="text" 
              placeholder="Search by name, skills, or location..."
              class="search-input"
            >
            <button class="search-button">🔍</button>
          </div>
          
          <div class="filter-tags">
            <span 
              v-for="(label, key) in matchingStore.filters" 
              :key="key"
              :class="['filter-tag', { active: matchingStore.activeFilter === key }]"
              @click="matchingStore.filterUsers(key)"
            >
              {{ label }}
            </span>
          </div>
        </div>
      </div>

      <!-- Loading State -->
      <div v-if="matchingStore.loading" class="loading-section">
        <div class="loading-spinner"></div>
        <p class="loading-text">Finding your matches...</p>
      </div>

      <!-- Error State -->
      <div v-else-if="matchingStore.error" class="error-section">
        <div class="error-card">
          <div class="error-icon">⚠️</div>
          <h3 class="error-title">Oops! Something went wrong</h3>
          <p class="error-message">{{ matchingStore.error }}</p>
          <button @click="retryFetch" class="retry-button">Try Again</button>
        </div>
      </div>

      <!-- Matches Grid -->
      <div v-else-if="matchingStore.users.length > 0" class="matches-section">
        <div class="section-header">
          <h2 class="section-title">Your Matches ({{ matchingStore.users.length }})</h2>
          <button @click="matchingStore.clearFilters()" class="clear-filters-btn">Clear Filters</button>
        </div>
        
        <div class="matches-grid">
          <div 
            class="match-card" 
            v-for="match in matchingStore.users" 
            :key="match.user.id"
            @click="viewUserProfile(match.user.id)"
          >
            <div class="match-header">
              <div class="match-avatar">
                {{ getAvatarEmoji(match.user) }}
              </div>
              <div class="match-info">
                <h3 class="match-name">{{ match.user.first_name }} {{ match.user.last_name }}</h3>
                <p class="match-location">{{ match.user.address || 'Location not specified' }}</p>
                <div class="match-score">
                  <span class="score-label">Match:</span>
                  <span class="score-value">{{ Math.round(match.match_percentage) }}%</span>
                </div>
              </div>
            </div>
            
            <div class="match-skills" v-if="match.user.skills && match.user.skills.length > 0">
              <h4>Top Skills:</h4>
              <div class="skills-tags">
                <span 
                  class="skill-tag" 
                  v-for="skill in match.user.skills.slice(0, 3)" 
                  :key="skill.id"
                >
                  {{ skill.value }}
                </span>
                <span v-if="match.user.skills.length > 3" class="skill-tag more-skills">
                  +{{ match.user.skills.length - 3 }} more
                </span>
              </div>
            </div>
            
            <div class="match-bio" v-if="match.user.bio">
              <p class="bio-text">{{ truncateText(match.user.bio, 100) }}</p>
            </div>
            
            <div class="match-actions">
              <button class="action-btn primary" @click.stop="viewUserProfile(match.user.id)">
                View Profile
              </button>
              <button class="action-btn secondary" @click.stop="calculateMatch(match.user.id)">
                Match Details
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Empty State -->
      <div v-else class="empty-section">
        <div class="empty-card">
          <div class="empty-icon">🔍</div>
          <h3 class="empty-title">No matches found</h3>
          <p class="empty-message">
            {{ matchingStore.searchQuery || matchingStore.activeFilter !== 'all' 
              ? 'Try adjusting your search or filters' 
              : 'No users found. Check back later!' }}
          </p>
          <button v-if="matchingStore.searchQuery || matchingStore.activeFilter !== 'all'" 
                  @click="matchingStore.clearFilters()" 
                  class="clear-filters-btn">
            Clear Filters
          </button>
        </div>
      </div>

      <!-- Compatibility Details Modal -->
      <div v-if="matchingStore.matchDetails" class="modal-overlay" @click="closeMatchDetails">
        <div class="modal-content" @click.stop>
          <div class="modal-header">
            <h2 class="modal-title">Match Details</h2>
            <button @click="closeMatchDetails" class="modal-close">×</button>
          </div>
          
          <div class="modal-body">
            <div class="match-summary">
              <div class="match-user-info">
                <div class="match-avatar-large">
                  {{ getAvatarEmoji(matchingStore.matchDetails.user) }}
                </div>
                <div class="match-user-details">
                  <h3>{{ matchingStore.matchDetails.user.first_name }} {{ matchingStore.matchDetails.user.last_name }}</h3>
                  <p class="match-percentage-large">{{ Math.round(matchingStore.matchDetails.match_percentage) }}% Match</p>
                </div>
              </div>
            </div>
            
            <div class="compatibility-breakdown">
              <h3>Compatibility Breakdown</h3>
              <div class="breakdown-grid">
                <div 
                  v-for="item in matchingStore.getMatchBreakdown" 
                  :key="item.name"
                  class="breakdown-item"
                >
                  <div class="breakdown-header">
                    <span class="breakdown-icon">{{ item.icon }}</span>
                    <span class="breakdown-name">{{ item.name }}</span>
                    <span class="breakdown-percentage">{{ item.percentage }}%</span>
                  </div>
                  <p class="breakdown-description">{{ item.description }}</p>
                  <div class="breakdown-bar">
                    <div class="bar-fill" :style="{ width: item.percentage + '%' }"></div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </BaseLayout>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useMatchingStore } from '@/stores/matching'
import BaseLayout from '@/components/layouts/BaseLayout.vue'

const router = useRouter()
const matchingStore = useMatchingStore()
const searchTimeout = ref(null)

// Load users on component mount
onMounted(async () => {
  await matchingStore.fetchUsers()
})

const handleSearch = () => {
  // Debounce search to avoid too many API calls
  clearTimeout(searchTimeout.value)
  searchTimeout.value = setTimeout(() => {
    matchingStore.searchUsers(matchingStore.searchQuery)
  }, 500)
}

const retryFetch = async () => {
  matchingStore.clearError()
  await matchingStore.fetchUsers()
}

const viewUserProfile = (userId) => {
  router.push(`/user/${userId}`)
}

const calculateMatch = async (userId) => {
  try {
    await matchingStore.calculateMatch(userId)
  } catch (error) {
    console.error('Error calculating match:', error)
  }
}

const closeMatchDetails = () => {
  matchingStore.clearMatchDetails()
}

const getAvatarEmoji = (user) => {
  // Generate avatar emoji based on user's first name
  const emojis = ['👨‍💻', '👩‍💻', '👨‍🎨', '👩‍🎨', '👨‍🔬', '👩‍🔬', '👨‍🏫', '👩‍🏫', '👨‍🎵', '👩‍🎵']
  const index = user.first_name?.charCodeAt(0) || 0
  return emojis[index % emojis.length]
}

const truncateText = (text, maxLength) => {
  if (!text) return ''
  return text.length > maxLength ? text.substring(0, maxLength) + '...' : text
}
</script>

<style scoped>
.matching-container {
  width: 100%;
  max-width: 1200px;
  padding: 20px;
  margin: 0 auto;
}

/* Header */
.matching-header {
  text-align: center;
  margin-bottom: 40px;
  animation: fadeInDown 1s ease-out;
}

.matching-title {
  font-size: 3rem;
  font-weight: 700;
  color: white;
  margin-bottom: 10px;
  background: linear-gradient(135deg, #ff6b6b, #ffd93d, #4ecdc4);
  background-clip: text;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  text-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
}

.matching-subtitle {
  font-size: 1.2rem;
  color: rgba(255, 255, 255, 0.8);
  font-weight: 400;
}

/* Search Section */
.search-section {
  margin-bottom: 40px;
}

.search-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  border-radius: 20px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  padding: 25px;
  animation: slideInUp 1s ease-out 0.2s forwards;
  opacity: 0;
}

.search-input-group {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
}

.search-input {
  flex: 1;
  padding: 15px 20px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 12px;
  color: white;
  font-size: 1rem;
  transition: all 0.3s ease;
}

.search-input::placeholder {
  color: rgba(255, 255, 255, 0.6);
}

.search-input:focus {
  outline: none;
  border-color: rgba(255, 255, 255, 0.5);
  background: rgba(255, 255, 255, 0.15);
}

.search-button {
  padding: 15px 20px;
  background: linear-gradient(135deg, #ff6b6b, #ffd93d);
  border: none;
  border-radius: 12px;
  color: white;
  font-size: 1.2rem;
  cursor: pointer;
  transition: all 0.3s ease;
}

.search-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
}

.filter-tags {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.filter-tag {
  padding: 8px 16px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.3);
  border-radius: 20px;
  color: rgba(255, 255, 255, 0.8);
  font-size: 0.9rem;
  cursor: pointer;
  transition: all 0.3s ease;
}

.filter-tag:hover,
.filter-tag.active {
  background: rgba(255, 255, 255, 0.2);
  border-color: rgba(255, 255, 255, 0.5);
  color: white;
}

/* Loading State */
.loading-section {
  text-align: center;
  padding: 60px 20px;
  animation: fadeInUp 1s ease-out 0.4s forwards;
  opacity: 0;
}

.loading-spinner {
  width: 50px;
  height: 50px;
  border: 3px solid rgba(255, 255, 255, 0.3);
  border-top: 3px solid #4ecdc4;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin: 0 auto 20px;
}

.loading-text {
  color: rgba(255, 255, 255, 0.8);
  font-size: 1.1rem;
  font-weight: 500;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* Error State */
.error-section {
  text-align: center;
  padding: 60px 20px;
  animation: fadeInUp 1s ease-out 0.4s forwards;
  opacity: 0;
}

.error-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  border-radius: 20px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  padding: 40px;
  max-width: 500px;
  margin: 0 auto;
}

.error-icon {
  font-size: 4rem;
  margin-bottom: 20px;
  color: #ff6b6b;
}

.error-title {
  font-size: 2rem;
  font-weight: 600;
  color: white;
  margin-bottom: 15px;
}

.error-message {
  color: rgba(255, 255, 255, 0.7);
  font-size: 1rem;
  margin-bottom: 30px;
  line-height: 1.6;
}

.retry-button {
  padding: 12px 24px;
  background: linear-gradient(135deg, #ff6b6b, #ffd93d);
  border: none;
  border-radius: 12px;
  color: white;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.retry-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
}

/* Matches Section */
.matches-section {
  margin-bottom: 40px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.section-title {
  font-size: 1.8rem;
  font-weight: 600;
  color: white;
  margin-bottom: 0;
  text-align: left;
}

.clear-filters-btn {
  padding: 8px 16px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.3);
  border-radius: 10px;
  color: white;
  font-size: 0.9rem;
  cursor: pointer;
  transition: all 0.3s ease;
}

.clear-filters-btn:hover {
  background: rgba(255, 255, 255, 0.2);
  border-color: rgba(255, 255, 255, 0.5);
}

.matches-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 20px;
}

.match-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  border-radius: 20px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  padding: 25px;
  transition: all 0.3s ease;
  animation: slideInUp 1s ease-out 0.4s forwards;
  opacity: 0;
  cursor: pointer;
}

.match-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
}

.match-header {
  display: flex;
  align-items: center;
  gap: 15px;
  margin-bottom: 20px;
}

.match-avatar {
  font-size: 3rem;
  width: 60px;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 15px;
}

.match-info {
  flex: 1;
}

.match-name {
  color: white;
  font-size: 1.3rem;
  font-weight: 600;
  margin-bottom: 5px;
}

.match-location {
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.9rem;
  margin-bottom: 8px;
}

.match-score {
  display: flex;
  align-items: center;
  gap: 5px;
}

.score-label {
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.8rem;
}

.score-value {
  color: #4ecdc4;
  font-weight: 700;
  font-size: 1rem;
}

.match-skills {
  margin-bottom: 20px;
}

.match-skills h4 {
  color: rgba(255, 255, 255, 0.8);
  font-size: 0.9rem;
  margin-bottom: 10px;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.skills-tags {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.skill-tag {
  padding: 4px 12px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 15px;
  color: rgba(255, 255, 255, 0.8);
  font-size: 0.8rem;
}

.skill-tag.more-skills {
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  color: rgba(255, 255, 255, 0.6);
  font-size: 0.7rem;
}

.match-bio {
  margin-bottom: 20px;
}

.bio-text {
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.9rem;
  line-height: 1.5;
  text-align: justify;
}

.match-actions {
  display: flex;
  gap: 10px;
}

.action-btn {
  flex: 1;
  padding: 10px;
  border: none;
  border-radius: 10px;
  font-size: 0.9rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
}

.action-btn.primary {
  background: linear-gradient(135deg, #ff6b6b, #ffd93d);
  color: white;
}

.action-btn.secondary {
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.3);
  color: white;
}

.action-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
}

/* Empty State */
.empty-section {
  text-align: center;
  padding: 50px 20px;
  animation: fadeInUp 1s ease-out 0.8s forwards;
  opacity: 0;
}

.empty-card {
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(10px);
  border-radius: 20px;
  border: 1px solid rgba(255, 255, 255, 0.1);
  padding: 30px;
  max-width: 400px;
  margin: 0 auto;
}

.empty-icon {
  font-size: 4rem;
  margin-bottom: 20px;
  color: rgba(255, 255, 255, 0.5);
}

.empty-title {
  font-size: 2rem;
  font-weight: 600;
  color: white;
  margin-bottom: 10px;
}

.empty-message {
  color: rgba(255, 255, 255, 0.7);
  font-size: 1rem;
  margin-bottom: 30px;
  line-height: 1.6;
}

/* Compatibility Section */
.compatibility-section {
  margin-bottom: 40px;
}

.compatibility-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 20px;
}

.compatibility-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  border-radius: 20px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  padding: 25px;
  text-align: center;
  transition: all 0.3s ease;
  animation: slideInUp 1s ease-out 0.6s forwards;
  opacity: 0;
}

.compatibility-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
}

.compatibility-icon {
  font-size: 2.5rem;
  margin-bottom: 15px;
}

.compatibility-card h3 {
  color: white;
  font-size: 1.2rem;
  font-weight: 600;
  margin-bottom: 10px;
}

.compatibility-card p {
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.9rem;
  margin-bottom: 15px;
  line-height: 1.4;
}

.compatibility-bar {
  width: 100%;
  height: 8px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 4px;
  margin-bottom: 10px;
  overflow: hidden;
}

.bar-fill {
  height: 100%;
  background: linear-gradient(90deg, #4ecdc4, #44a08d);
  border-radius: 4px;
  transition: width 0.3s ease;
}

.compatibility-percentage {
  color: #4ecdc4;
  font-weight: 700;
  font-size: 1.1rem;
}

/* Modal */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.7);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  animation: fadeIn 0.5s ease-out;
}

.modal-content {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  border-radius: 20px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  padding: 30px;
  max-width: 600px;
  width: 90%;
  position: relative;
  animation: slideInUp 0.5s ease-out;
  opacity: 0;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 25px;
  padding-bottom: 20px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.modal-title {
  font-size: 2rem;
  font-weight: 700;
  color: white;
  margin: 0;
  background: linear-gradient(135deg, #ff6b6b, #ffd93d, #4ecdc4);
  background-clip: text;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  text-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
}

.modal-close {
  background: none;
  border: none;
  font-size: 2rem;
  color: white;
  cursor: pointer;
  transition: all 0.3s ease;
}

.modal-close:hover {
  transform: rotate(90deg);
}

.modal-body {
  display: flex;
  flex-direction: column;
  gap: 25px;
}

.match-summary {
  display: flex;
  align-items: center;
  gap: 20px;
  margin-bottom: 20px;
  padding-bottom: 20px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.match-user-info {
  display: flex;
  align-items: center;
  gap: 15px;
}

.match-avatar-large {
  font-size: 4rem;
  width: 80px;
  height: 80px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 20px;
}

.match-user-details {
  display: flex;
  flex-direction: column;
}

.match-user-details h3 {
  color: white;
  font-size: 1.8rem;
  font-weight: 700;
  margin-bottom: 5px;
}

.match-percentage-large {
  color: #4ecdc4;
  font-size: 1.2rem;
  font-weight: 600;
}

.compatibility-breakdown {
  margin-top: 20px;
  padding-top: 20px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.compatibility-breakdown h3 {
  font-size: 1.4rem;
  font-weight: 600;
  color: white;
  margin-bottom: 15px;
  text-align: left;
}

.breakdown-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 15px;
}

.breakdown-item {
  background: rgba(255, 255, 255, 0.08);
  backdrop-filter: blur(10px);
  border-radius: 15px;
  padding: 15px;
  text-align: left;
  transition: all 0.3s ease;
}

.breakdown-item:hover {
  transform: translateY(-3px);
  box-shadow: 0 8px 15px rgba(0, 0, 0, 0.1);
}

.breakdown-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.breakdown-icon {
  font-size: 1.8rem;
  margin-right: 10px;
  color: #4ecdc4;
}

.breakdown-name {
  color: white;
  font-size: 1rem;
  font-weight: 500;
  flex: 1;
}

.breakdown-percentage {
  color: #4ecdc4;
  font-weight: 700;
  font-size: 1rem;
}

.breakdown-description {
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.8rem;
  margin-bottom: 10px;
  line-height: 1.4;
}

.breakdown-bar {
  width: 100%;
  height: 6px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 3px;
  overflow: hidden;
}

.bar-fill {
  height: 100%;
  background: linear-gradient(90deg, #4ecdc4, #44a08d);
  border-radius: 3px;
  transition: width 0.3s ease;
}

/* Animations */
@keyframes fadeInDown {
  from {
    opacity: 0;
    transform: translateY(-30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes slideInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

/* Responsive Design */
@media (max-width: 768px) {
  .matching-container {
    padding: 15px;
  }
  
  .matching-title {
    font-size: 2.5rem;
  }
  
  .matches-grid {
    grid-template-columns: 1fr;
  }
  
  .compatibility-grid {
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  }
  
  .search-input-group {
    flex-direction: column;
  }
  
  .match-actions {
    flex-direction: column;
  }

  .modal-content {
    padding: 20px;
  }

  .modal-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }

  .modal-title {
    font-size: 1.8rem;
  }

  .modal-close {
    align-self: flex-end;
  }

  .match-summary {
    flex-direction: column;
    align-items: flex-start;
    gap: 15px;
  }

  .match-user-info {
    flex-direction: column;
    align-items: center;
    text-align: center;
  }

  .match-avatar-large {
    font-size: 3rem;
    width: 60px;
    height: 60px;
  }

  .match-user-details h3 {
    font-size: 1.5rem;
  }

  .match-percentage-large {
    font-size: 1rem;
  }

  .compatibility-breakdown h3 {
    font-size: 1.2rem;
  }

  .breakdown-grid {
    grid-template-columns: 1fr;
  }

  .breakdown-item {
    padding: 10px;
  }

  .breakdown-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 5px;
  }

  .breakdown-icon {
    font-size: 1.5rem;
  }

  .breakdown-name {
    font-size: 0.9rem;
  }

  .breakdown-percentage {
    font-size: 0.9rem;
  }

  .breakdown-description {
    font-size: 0.7rem;
  }

  .breakdown-bar {
    height: 5px;
  }
}

@media (max-width: 480px) {
  .matching-title {
    font-size: 2rem;
  }
  
  .match-card {
    padding: 20px;
  }
  
  .match-header {
    flex-direction: column;
    text-align: center;
  }
}
</style> 