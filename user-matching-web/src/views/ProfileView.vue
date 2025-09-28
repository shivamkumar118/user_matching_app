<template>
  <BaseLayout>
    <div class="profile-container">
      <!-- Header -->
      <div class="profile-header">
        <h1 class="profile-title">Profile</h1>
        <p class="profile-subtitle">Manage your personal information</p>
      </div>

      <!-- Loading State -->
      <div v-if="userStore.loading && !userStore.profile" class="loading-container">
        <div class="loading-spinner"></div>
        <p>Loading profile...</p>
      </div>

      <!-- Error State -->
      <div v-else-if="userStore.error" class="error-container">
        <p>{{ userStore.error }}</p>
        <button @click="loadProfileData" class="retry-button">Retry</button>
      </div>

      <!-- Profile Content -->
      <div v-else class="profile-content">
        <!-- Personal Information -->
        <div class="profile-card">
          <div class="card-header">
            <h2>Personal Information</h2>
            <button class="edit-button" @click="editPersonalInfo">Edit</button>
          </div>
          
          <div class="profile-info">
            <div class="info-row">
              <span class="info-label">Name:</span>
              <span class="info-value">{{ userStore.profile?.first_name }} {{ userStore.profile?.last_name }}</span>
            </div>
            <div class="info-row">
              <span class="info-label">Email:</span>
              <span class="info-value">{{ userStore.profile?.email }}</span>
            </div>
            <div class="info-row">
              <span class="info-label">Phone:</span>
              <span class="info-value">{{ userStore.profile?.phone || 'Not provided' }}</span>
            </div>
            <div class="info-row">
              <span class="info-label">Address:</span>
              <span class="info-value">{{ userStore.profile?.address || 'Not provided' }}</span>
            </div>
            <div class="info-row">
              <span class="info-label">Employment:</span>
              <span class="info-value">{{ formatEmploymentStatus(userStore.profile?.employment_status) }}</span>
            </div>
          </div>
        </div>

        <!-- About Me -->
        <div class="profile-card">
          <div class="card-header">
            <h2>About Me</h2>
            <button class="edit-button" @click="editAboutMe">Edit</button>
          </div>
          
          <div class="about-content">
            <p v-if="userStore.profile?.bio">{{ userStore.profile.bio }}</p>
            <p v-else class="empty-state">No bio added yet. Click "Edit" to add your bio.</p>
          </div>
        </div>

        <!-- Skills -->
        <div class="profile-card">
          <div class="card-header">
            <h2>Skills</h2>
            <button class="edit-button" @click="addSkill">Add Skill</button>
          </div>
          
          <div v-if="userStore.skills.length > 0" class="skills-grid">
            <div v-for="skill in userStore.skills" :key="skill.id" class="skill-item">
              <span class="skill-name">{{ skill.value }}</span>
              <div class="skill-rating">
                <span v-for="i in 5" :key="i" class="star" :class="{ filled: i <= skill.rating }">
                  {{ i <= skill.rating ? '★' : '☆' }}
                </span>
              </div>
              <button class="delete-skill-btn" @click="deleteSkill(skill.id)" title="Delete skill">
                <svg class="delete-icon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z" fill="currentColor"/>
                </svg>
              </button>
            </div>
          </div>
          <div v-else class="empty-state">
            <p>No skills added yet. Click "Add Skill" to add your skills.</p>
          </div>
        </div>

        <!-- Experience -->
        <div class="profile-card">
          <div class="card-header">
            <h2>Experience</h2>
            <button class="edit-button" @click="addExperience">Add Experience</button>
          </div>
          
          <div v-if="userStore.experiences.length > 0" class="experience-list">
            <div v-for="experience in userStore.experiences" :key="experience.id" class="experience-item">
              <div class="experience-header">
                <h3>{{ experience.job_title }}</h3>
                <span class="experience-period">{{ formatDate(experience.start_date) }} - {{ experience.end_date ? formatDate(experience.end_date) : 'Present' }}</span>
              </div>
              <p class="company-name">{{ experience.company_name }}</p>
              <p class="experience-description">{{ experience.description }}</p>
              <div class="experience-actions">
                <button class="edit-exp-btn" @click="editExperience(experience)">Edit</button>
                <button class="delete-exp-btn" @click="deleteExperience(experience.id)">Delete</button>
              </div>
            </div>
          </div>
          <div v-else class="empty-state">
            <p>No experience added yet. Click "Add Experience" to add your work experience.</p>
          </div>
        </div>
      </div>

      <!-- Modals -->
      <PersonalInfoModal 
        v-if="showPersonalInfoModal" 
        :profile="userStore.profile"
        @close="showPersonalInfoModal = false"
        @save="savePersonalInfo"
      />
      
      <AboutMeModal 
        v-if="showAboutMeModal" 
        :bio="userStore.profile?.bio"
        @close="showAboutMeModal = false"
        @save="saveAboutMe"
      />
      
      <SkillModal 
        v-if="showSkillModal" 
        :skill="editingSkill"
        @close="closeSkillModal"
        @save="saveSkill"
      />
      
      <ExperienceModal 
        v-if="showExperienceModal" 
        :experience="editingExperience"
        @close="closeExperienceModal"
        @save="saveExperience"
      />
    </div>
  </BaseLayout>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useUserStore } from '@/stores/user'
import BaseLayout from '@/components/layouts/BaseLayout.vue'
import PersonalInfoModal from '@/components/modals/PersonalInfoModal.vue'
import AboutMeModal from '@/components/modals/AboutMeModal.vue'
import SkillModal from '@/components/modals/SkillModal.vue'
import ExperienceModal from '@/components/modals/ExperienceModal.vue'

const userStore = useUserStore()

// Modal states
const showPersonalInfoModal = ref(false)
const showAboutMeModal = ref(false)
const showSkillModal = ref(false)
const showExperienceModal = ref(false)

// Editing states
const editingSkill = ref(null)
const editingExperience = ref(null)

// Load profile data on mount
onMounted(() => {
  loadProfileData()
})

const loadProfileData = async () => {
  try {
    await Promise.all([
      userStore.fetchProfile(),
      userStore.fetchSkills(),
      userStore.fetchExperiences()
    ])
  } catch (error) {
    console.error('Failed to load profile data:', error)
  }
}

// Personal Info
const editPersonalInfo = () => {
  showPersonalInfoModal.value = true
}

const savePersonalInfo = async (data) => {
  try {
    await userStore.updateProfile(data)
    showPersonalInfoModal.value = false
  } catch (error) {
    console.error('Failed to update personal info:', error)
  }
}

// About Me
const editAboutMe = () => {
  showAboutMeModal.value = true
}

const saveAboutMe = async (bio) => {
  try {
    await userStore.updateProfile({ bio })
    showAboutMeModal.value = false
  } catch (error) {
    console.error('Failed to update bio:', error)
  }
}

// Skills
const addSkill = () => {
  editingSkill.value = null
  showSkillModal.value = true
}

const editSkill = (skill) => {
  editingSkill.value = skill
  showSkillModal.value = true
}

const closeSkillModal = () => {
  showSkillModal.value = false
  editingSkill.value = null
}

const saveSkill = async (skillData) => {
  try {
    if (editingSkill.value) {
      await userStore.updateSkill(editingSkill.value.id, skillData)
    } else {
      await userStore.createSkill(skillData)
    }
    closeSkillModal()
  } catch (error) {
    console.error('Failed to save skill:', error)
  }
}

const deleteSkill = async (id) => {
  if (confirm('Are you sure you want to delete this skill?')) {
    try {
      await userStore.deleteSkill(id)
    } catch (error) {
      console.error('Failed to delete skill:', error)
    }
  }
}

// Experiences
const addExperience = () => {
  editingExperience.value = null
  showExperienceModal.value = true
}

const editExperience = (experience) => {
  editingExperience.value = experience
  showExperienceModal.value = true
}

const closeExperienceModal = () => {
  showExperienceModal.value = false
  editingExperience.value = null
}

const saveExperience = async (experienceData) => {
  try {
    if (editingExperience.value) {
      await userStore.updateExperience(editingExperience.value.id, experienceData)
    } else {
      await userStore.createExperience(experienceData)
    }
    closeExperienceModal()
  } catch (error) {
    console.error('Failed to save experience:', error)
  }
}

const deleteExperience = async (id) => {
  if (confirm('Are you sure you want to delete this experience?')) {
    try {
      await userStore.deleteExperience(id)
    } catch (error) {
      console.error('Failed to delete experience:', error)
    }
  }
}

// Utility functions
const formatEmploymentStatus = (status) => {
  if (!status) return 'Not specified'
  return status.charAt(0).toUpperCase() + status.slice(1)
}

const formatDate = (dateString) => {
  if (!dateString) return ''
  const date = new Date(dateString)
  return date.toLocaleDateString('en-US', { year: 'numeric', month: 'short' })
}
</script>

<style scoped>
.profile-container {
  width: 100%;
  max-width: 800px;
  padding: 20px;
  margin: 0 auto;
}

/* Header */
.profile-header {
  text-align: center;
  margin-bottom: 40px;
  animation: fadeInDown 1s ease-out;
}

.profile-title {
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

.profile-subtitle {
  font-size: 1.2rem;
  color: rgba(255, 255, 255, 0.8);
  font-weight: 400;
}

/* Loading and Error States */
.loading-container, .error-container {
  text-align: center;
  padding: 40px 0;
  color: rgba(255, 255, 255, 0.8);
  font-size: 1.1rem;
}

.loading-spinner {
  border: 4px solid rgba(255, 255, 255, 0.3);
  border-top: 4px solid white;
  border-radius: 50%;
  width: 40px;
  height: 40px;
  animation: spin 1s linear infinite;
  margin: 0 auto 20px;
}

.retry-button {
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.3);
  color: white;
  padding: 10px 20px;
  border-radius: 20px;
  cursor: pointer;
  font-size: 1rem;
  transition: all 0.3s ease;
}

.retry-button:hover {
  background: rgba(255, 255, 255, 0.2);
  border-color: rgba(255, 255, 255, 0.5);
}

/* Profile Content */
.profile-content {
  display: flex;
  flex-direction: column;
  gap: 30px;
}

.profile-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  border-radius: 20px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  padding: 30px;
  transition: all 0.3s ease;
  animation: slideInUp 1s ease-out 0.2s forwards;
  opacity: 0;
}

.profile-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
}

.profile-card:nth-child(2) {
  animation-delay: 0.4s;
}

.profile-card:nth-child(3) {
  animation-delay: 0.6s;
}

.profile-card:nth-child(4) {
  animation-delay: 0.8s;
}

/* Card Header */
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding-bottom: 15px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
}

.card-header h2 {
  color: white;
  font-size: 1.5rem;
  font-weight: 600;
}

.edit-button {
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.3);
  color: white;
  padding: 8px 16px;
  border-radius: 20px;
  cursor: pointer;
  font-size: 0.9rem;
  transition: all 0.3s ease;
}

.edit-button:hover {
  background: rgba(255, 255, 255, 0.2);
  border-color: rgba(255, 255, 255, 0.5);
}

/* Profile Info */
.profile-info {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.info-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 0;
}

.info-label {
  color: rgba(255, 255, 255, 0.7);
  font-weight: 500;
  font-size: 0.9rem;
}

.info-value {
  color: white;
  font-weight: 600;
}

/* About Content */
.about-content p {
  color: rgba(255, 255, 255, 0.9);
  line-height: 1.6;
  font-size: 1rem;
}

.empty-state {
  color: rgba(255, 255, 255, 0.6);
  font-style: italic;
}

/* Skills Grid */
.skills-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 15px;
}

.skill-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 10px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.skill-name {
  color: white;
  font-weight: 500;
}

.skill-rating {
  display: flex;
  gap: 2px;
}

.star {
  color: #ffd700;
  font-size: 1.1rem;
}

.filled {
  color: #ffd700;
}

.delete-skill-btn {
  background: linear-gradient(135deg, rgba(255, 107, 107, 0.2), rgba(255, 107, 107, 0.1));
  border: 2px solid rgba(255, 107, 107, 0.4);
  color: #ff6b6b;
  padding: 8px;
  border-radius: 12px;
  cursor: pointer;
  font-size: 0.8rem;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  position: relative;
  overflow: hidden;
}

.delete-skill-btn::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
  transition: left 0.5s ease;
}

.delete-skill-btn:hover::before {
  left: 100%;
}

.delete-skill-btn:hover {
  background: linear-gradient(135deg, rgba(255, 107, 107, 0.3), rgba(255, 107, 107, 0.2));
  border-color: rgba(255, 107, 107, 0.6);
  color: #ff4757;
  transform: translateY(-2px) scale(1.05);
  box-shadow: 0 6px 20px rgba(255, 107, 107, 0.3);
}

.delete-skill-btn:active {
  transform: translateY(0) scale(0.95);
}

.delete-icon {
  width: 16px;
  height: 16px;
  transition: all 0.3s ease;
}

.delete-skill-btn:hover .delete-icon {
  transform: rotate(90deg) scale(1.1);
}

/* Experience List */
.experience-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.experience-item {
  padding: 20px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 15px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.experience-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.experience-header h3 {
  color: white;
  font-size: 1.2rem;
  font-weight: 600;
}

.experience-period {
  color: rgba(255, 255, 255, 0.6);
  font-size: 0.9rem;
  font-weight: 500;
}

.company-name {
  color: rgba(255, 255, 255, 0.8);
  font-weight: 500;
  margin-bottom: 10px;
}

.experience-description {
  color: rgba(255, 255, 255, 0.7);
  line-height: 1.5;
  font-size: 0.9rem;
}

.experience-actions {
  display: flex;
  gap: 10px;
  margin-top: 15px;
}

.edit-exp-btn, .delete-exp-btn {
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.3);
  color: white;
  padding: 8px 12px;
  border-radius: 15px;
  cursor: pointer;
  font-size: 0.8rem;
  transition: all 0.3s ease;
}

.edit-exp-btn:hover {
  background: rgba(255, 255, 255, 0.2);
  border-color: rgba(255, 255, 255, 0.5);
}

.delete-exp-btn {
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  color: #ff6b6b;
}

.delete-exp-btn:hover {
  background: rgba(255, 255, 255, 0.1);
  border-color: rgba(255, 255, 255, 0.2);
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

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* Responsive Design */
@media (max-width: 768px) {
  .profile-container {
    padding: 15px;
  }
  
  .profile-title {
    font-size: 2.5rem;
  }
  
  .skills-grid {
    grid-template-columns: 1fr;
  }
  
  .experience-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 5px;
  }
}

@media (max-width: 480px) {
  .profile-title {
    font-size: 2rem;
  }
  
  .profile-card {
    padding: 20px;
  }
  
  .info-row {
    flex-direction: column;
    align-items: flex-start;
    gap: 5px;
  }
}
</style> 