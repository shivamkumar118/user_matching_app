<template>
  <BaseLayout>
    <div class="dashboard-container">
      <!-- Header -->
      <div class="dashboard-header">
        <h1 class="dashboard-title">Dashboard</h1>
        <p class="dashboard-subtitle">Welcome back, {{ authStore.userFullName || 'User' }}!</p>
      </div>

      <!-- Loading State -->
      <div v-if="userStore.loading" class="loading-container">
        <div class="loading-spinner"></div>
        <p>Loading dashboard data...</p>
      </div>

      <!-- Dashboard Content -->
      <div v-else>
        <!-- Stats Cards -->
        <div class="stats-grid">
          <div class="stat-card">
            <div class="stat-icon">👥</div>
            <div class="stat-content">
              <h3 class="stat-title">Total Users</h3>
              <p class="stat-value">{{ totalUsers }}</p>
            </div>
          </div>
          
          <div class="stat-card">
            <div class="stat-icon">💝</div>
            <div class="stat-content">
              <h3 class="stat-title">Your Matches</h3>
              <p class="stat-value">{{ userMatches }}%</p>
            </div>
          </div>
          
          <div class="stat-card">
            <div class="stat-icon">📊</div>
            <div class="stat-content">
              <h3 class="stat-title">Profile Complete</h3>
              <p class="stat-value">{{ userStore.profileCompletionPercentage }}%</p>
            </div>
          </div>
          
          <div class="stat-card">
            <div class="stat-icon">🎯</div>
            <div class="stat-content">
              <h3 class="stat-title">Questions Answered</h3>
              <p class="stat-value">{{ userStore.answeredQuestionsCount }}/{{ userStore.totalQuestionsCount }}</p>
            </div>
          </div>
        </div>

        <!-- Quick Actions -->
        <div class="actions-section">
          <h2 class="section-title">Quick Actions</h2>
          <div class="actions-grid">
            <router-link to="/profile" class="action-card">
              <div class="action-icon">👤</div>
              <h3>Edit Profile</h3>
              <p>Update your information</p>
            </router-link>
            
            <router-link to="/questions" class="action-card">
              <div class="action-icon">❓</div>
              <h3>Answer Questions</h3>
              <p>Complete your profile</p>
            </router-link>
            
            <router-link to="/matching" class="action-card">
              <div class="action-icon">🔍</div>
              <h3>Find Matches</h3>
              <p>Discover new connections</p>
            </router-link>
            
            <router-link to="/profile" class="action-card">
              <div class="action-icon">📈</div>
              <h3>View Stats</h3>
              <p>See your analytics</p>
            </router-link>
          </div>
        </div>

        <!-- Recent Activity -->
        <div class="activity-section">
          <h2 class="section-title">Recent Activity</h2>
          <div class="activity-list">
            <div class="activity-item">
              <div class="activity-icon">🎉</div>
              <div class="activity-content">
                <h4>New Match Found!</h4>
                <p>You matched with Sarah (95% compatibility)</p>
                <span class="activity-time">2 hours ago</span>
              </div>
            </div>
            
            <div class="activity-item">
              <div class="activity-icon">📝</div>
              <div class="activity-content">
                <h4>Profile Updated</h4>
                <p>You updated your skills section</p>
                <span class="activity-time">1 day ago</span>
              </div>
            </div>
            
            <div class="activity-item">
              <div class="activity-icon">💬</div>
              <div class="activity-content">
                <h4>Message Received</h4>
                <p>John sent you a message</p>
                <span class="activity-time">2 days ago</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </BaseLayout>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useAuthStore } from '@/stores/auth'
import { useUserStore } from '@/stores/user'
import BaseLayout from '@/components/layouts/BaseLayout.vue'

const authStore = useAuthStore()
const userStore = useUserStore()

// Dashboard statistics
const totalUsers = ref(0)
const userMatches = ref(0)

// Load dashboard data on mount
onMounted(() => {
  loadDashboardData()
})

const loadDashboardData = async () => {
  try {
    // Load user profile data (for profile completion percentage)
    await userStore.fetchProfile()
    
    // Load questions and answers data (for questions answered count)
    await userStore.loadQuestionsData()
    
    // Load total users count from backend
    totalUsers.value = await userStore.getTotalUsersCount()
    
    // Load user matches from backend
    userMatches.value = await userStore.getUserMatches()
  } catch (error) {
    console.error('Failed to load dashboard data:', error)
  }
}
</script>

<style scoped>
.dashboard-container {
  width: 100%;
  max-width: 1200px;
  padding: 20px;
  margin: 0 auto;
}

/* Header */
.dashboard-header {
  text-align: center;
  margin-bottom: 40px;
  animation: fadeInDown 1s ease-out;
}

.dashboard-title {
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

.dashboard-subtitle {
  font-size: 1.2rem;
  color: rgba(255, 255, 255, 0.8);
  font-weight: 400;
}

/* Loading State */
.loading-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 200px;
  color: white;
  font-size: 1.2rem;
  font-weight: 500;
}

.loading-spinner {
  border: 4px solid rgba(255, 255, 255, 0.3);
  border-top: 4px solid #4ecdc4;
  border-radius: 50%;
  width: 50px;
  height: 50px;
  animation: spin 1s linear infinite;
  margin-bottom: 15px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* Stats Grid */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 20px;
  margin-bottom: 40px;
}

.stat-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  border-radius: 20px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  padding: 25px;
  display: flex;
  align-items: center;
  gap: 20px;
  transition: all 0.3s ease;
  animation: slideInUp 1s ease-out 0.2s forwards;
  opacity: 0;
}

.stat-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
}

.stat-icon {
  font-size: 2.5rem;
  width: 60px;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 15px;
}

.stat-content h3 {
  color: rgba(255, 255, 255, 0.8);
  font-size: 0.9rem;
  font-weight: 500;
  margin-bottom: 5px;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.stat-value {
  color: white;
  font-size: 2rem;
  font-weight: 700;
}

/* Actions Section */
.actions-section {
  margin-bottom: 40px;
}

.section-title {
  font-size: 1.8rem;
  font-weight: 600;
  color: white;
  margin-bottom: 20px;
  text-align: center;
}

.actions-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 20px;
}

.action-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  border-radius: 20px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  padding: 25px;
  text-align: center;
  text-decoration: none;
  color: white;
  transition: all 0.3s ease;
  animation: slideInUp 1s ease-out 0.4s forwards;
  opacity: 0;
}

.action-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
  color: white;
}

.action-icon {
  font-size: 2.5rem;
  margin-bottom: 15px;
}

.action-card h3 {
  font-size: 1.2rem;
  font-weight: 600;
  margin-bottom: 8px;
}

.action-card p {
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.9rem;
}

/* Activity Section */
.activity-section {
  margin-bottom: 40px;
}

.activity-list {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.activity-item {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  border-radius: 15px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  padding: 20px;
  display: flex;
  align-items: center;
  gap: 15px;
  transition: all 0.3s ease;
  animation: slideInUp 1s ease-out 0.6s forwards;
  opacity: 0;
}

.activity-item:hover {
  transform: translateX(5px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
}

.activity-icon {
  font-size: 1.5rem;
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 10px;
  flex-shrink: 0;
}

.activity-content h4 {
  color: white;
  font-size: 1rem;
  font-weight: 600;
  margin-bottom: 5px;
}

.activity-content p {
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.9rem;
  margin-bottom: 5px;
}

.activity-time {
  color: rgba(255, 255, 255, 0.5);
  font-size: 0.8rem;
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

/* Responsive Design */
@media (max-width: 768px) {
  .dashboard-container {
    padding: 15px;
  }
  
  .dashboard-title {
    font-size: 2.5rem;
  }
  
  .stats-grid {
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 15px;
  }
  
  .actions-grid {
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 15px;
  }
}

@media (max-width: 480px) {
  .dashboard-title {
    font-size: 2rem;
  }
  
  .stats-grid {
    grid-template-columns: 1fr;
  }
  
  .actions-grid {
    grid-template-columns: 1fr;
  }
}
</style> 