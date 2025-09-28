<template>
  <div class="base-layout">
    <!-- Animated Background Shapes -->
    <div class="background-shapes">
      <div class="shape"></div>
      <div class="shape"></div>
      <div class="shape"></div>
      <div class="shape"></div>
    </div>

    <!-- Login/Profile Icon -->
    <div class="auth-icon-container">
      <div v-if="!authStore.isAuthenticated" class="auth-icon">
        <router-link to="/login" class="login-link">
          <svg class="icon" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M3 3a1 1 0 011 1v12a1 1 0 11-2 0V4a1 1 0 011-1zm7.707 3.293a1 1 0 010 1.414L9.414 9H17a1 1 0 110 2H9.414l1.293 1.293a1 1 0 01-1.414 1.414l-3-3a1 1 0 010-1.414l3-3a1 1 0 011.414 0z" clip-rule="evenodd"></path>
          </svg>
          <span class="login-text">Login</span>
        </router-link>
      </div>
      <div v-else class="auth-icon">
        <div class="profile-dropdown" @click="toggleDropdown" ref="dropdownRef">
          <svg class="icon" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z" clip-rule="evenodd"></path>
          </svg>
          <span class="user-email">{{ authStore.user?.email }}</span>
          <svg class="dropdown-arrow" :class="{ 'rotated': showDropdown }" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd"></path>
          </svg>
        </div>
        
        <!-- Dropdown Menu -->
        <div v-if="showDropdown" class="dropdown-menu">
          <router-link to="/profile" class="dropdown-item" @click="showDropdown = false">
            <svg class="dropdown-icon" fill="currentColor" viewBox="0 0 20 20">
              <path fill-rule="evenodd" d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z" clip-rule="evenodd"></path>
            </svg>
            <span>Profile</span>
          </router-link>
          <div class="dropdown-item" @click="handleLogout">
            <svg class="dropdown-icon" fill="currentColor" viewBox="0 0 20 20">
              <path fill-rule="evenodd" d="M3 3a1 1 0 00-1 1v12a1 1 0 102 0V4a1 1 0 00-1-1zm10.293 9.293a1 1 0 001.414 1.414l3-3a1 1 0 000-1.414l-3-3a1 1 0 10-1.414 1.414L14.586 9H7a1 1 0 100 2h7.586l-1.293 1.293z" clip-rule="evenodd"></path>
            </svg>
            <span>Logout</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Header Navigation Menu -->
    <nav class="header-nav" v-if="authStore.isAuthenticated">
      <div class="nav-container">
        <router-link to="/dashboard" class="nav-link" active-class="active">
          <svg class="nav-icon" fill="currentColor" viewBox="0 0 20 20">
            <path d="M3 4a1 1 0 011-1h12a1 1 0 011 1v2a1 1 0 01-1 1H4a1 1 0 01-1-1V4zM3 10a1 1 0 011-1h6a1 1 0 011 1v6a1 1 0 01-1 1H4a1 1 0 01-1-1v-6zM14 9a1 1 0 00-1 1v6a1 1 0 001 1h2a1 1 0 001-1v-6a1 1 0 00-1-1h-2z"></path>
          </svg>
          <span>Go to Dashboard</span>
        </router-link>
        <router-link to="/matching" class="nav-link" active-class="active">
          <svg class="nav-icon" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z" clip-rule="evenodd"></path>
          </svg>
          <span>Find Matches</span>
        </router-link>
      </div>
    </nav>

    <!-- Content Slot -->
    <div class="content-wrapper">
      <slot></slot>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const router = useRouter()
const authStore = useAuthStore()

const showDropdown = ref(false)
const dropdownRef = ref(null)

const toggleDropdown = () => {
  showDropdown.value = !showDropdown.value
}

const handleLogout = async () => {
  await authStore.logout()
  showDropdown.value = false
  router.push('/login')
}

// Close dropdown when clicking outside
const handleClickOutside = (event) => {
  if (dropdownRef.value && !dropdownRef.value.contains(event.target)) {
    showDropdown.value = false
  }
}

onMounted(() => {
  document.addEventListener('click', handleClickOutside)
})

onUnmounted(() => {
  document.removeEventListener('click', handleClickOutside)
})
</script>

<style scoped>
.base-layout {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  width: 100vw;
  height: 100vh;
  background: linear-gradient(135deg, #9333ea 0%, #2563eb 50%, #4338ca 100%);
  overflow-x: hidden;
  margin: 0;
  padding: 0;
}

/* Animated Background Shapes */
.background-shapes {
  position: fixed;
  inset: 0;
  pointer-events: none;
  z-index: 1;
}

.shape {
  position: absolute;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.1);
  animation: float 6s ease-in-out infinite;
}

.shape:nth-child(1) {
  width: 100px;
  height: 100px;
  top: 15%;
  left: 10%;
  animation-delay: 0s;
}

.shape:nth-child(2) {
  width: 150px;
  height: 150px;
  top: 60%;
  right: 15%;
  animation-delay: 2s;
}

.shape:nth-child(3) {
  width: 80px;
  height: 80px;
  bottom: 20%;
  left: 20%;
  animation-delay: 4s;
}

.shape:nth-child(4) {
  width: 120px;
  height: 120px;
  top: 30%;
  right: 30%;
  animation-delay: 1s;
}

@keyframes float {
  0%, 100% { 
    transform: translateY(0px) rotate(0deg);
    opacity: 0.7;
  }
  50% { 
    transform: translateY(-30px) rotate(180deg);
    opacity: 1;
  }
}

/* Content Wrapper */
.content-wrapper {
  display: flex;
  flex-direction: column;
  align-items: center;
  z-index: 10;
  position: relative;
  width: 100%;
  max-width: 100%;
  min-height: 100vh;
  padding: 20px;
  padding-top: 80px;
  padding-bottom: 40px;
  overflow-x: hidden;
}

/* Auth Icon Container */
.auth-icon-container {
  position: fixed;
  top: 20px;
  right: 20px;
  z-index: 1000;
}

.auth-icon {
  display: flex;
  align-items: center;
}

/* Login Link */
.login-link {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 16px;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 25px;
  color: white;
  text-decoration: none;
  font-size: 14px;
  font-weight: 500;
  transition: all 0.3s ease;
}

.login-link:hover {
  background: rgba(255, 255, 255, 0.2);
  border-color: rgba(255, 255, 255, 0.4);
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
}

.login-text {
  font-weight: 600;
}

/* Profile Dropdown */
.profile-dropdown {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 16px;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 25px;
  color: white;
  cursor: pointer;
  font-size: 14px;
  font-weight: 500;
  transition: all 0.3s ease;
  position: relative;
}

.profile-dropdown:hover {
  background: rgba(255, 255, 255, 0.2);
  border-color: rgba(255, 255, 255, 0.4);
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
}

.user-email {
  font-weight: 600;
  max-width: 150px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.dropdown-arrow {
  width: 16px;
  height: 16px;
  transition: transform 0.3s ease;
}

.dropdown-arrow.rotated {
  transform: rotate(180deg);
}

/* Dropdown Menu */
.dropdown-menu {
  position: absolute;
  top: 100%;
  right: 0;
  margin-top: 8px;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 12px;
  padding: 8px 0;
  min-width: 160px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
  animation: slideDown 0.3s ease;
}

@keyframes slideDown {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.dropdown-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px 16px;
  color: white;
  cursor: pointer;
  font-size: 14px;
  transition: all 0.2s ease;
  text-decoration: none;
}

.dropdown-item:hover {
  background: rgba(255, 255, 255, 0.1);
  color: white;
  text-decoration: none;
}

.dropdown-item:first-child {
  border-radius: 12px 12px 0 0;
}

.dropdown-item:last-child {
  border-radius: 0 0 12px 12px;
}

.dropdown-icon {
  width: 16px;
  height: 16px;
  opacity: 0.8;
}

/* Icon Styles */
.icon {
  width: 18px;
  height: 18px;
  opacity: 0.9;
}

/* Header Navigation Menu */
.header-nav {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
  z-index: 999;
  padding: 10px 20px;
  display: flex;
  justify-content: center;
  align-items: center;
  height: 60px;
}

.nav-container {
  display: flex;
  gap: 20px;
  align-items: center;
}

.nav-link {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 12px;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 20px;
  color: white;
  text-decoration: none;
  font-size: 14px;
  font-weight: 500;
  transition: all 0.3s ease;
}

.nav-link:hover {
  background: rgba(255, 255, 255, 0.2);
  border-color: rgba(255, 255, 255, 0.4);
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
}

.nav-link.active {
  background: rgba(255, 255, 255, 0.3);
  border-color: rgba(255, 255, 255, 0.5);
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
}

.nav-icon {
  width: 20px;
  height: 20px;
  opacity: 0.9;
}

/* Responsive Design */
@media (max-width: 768px) {
  .auth-icon-container {
    top: 15px;
    right: 15px;
  }
  
  .login-link,
  .profile-dropdown {
    padding: 8px 12px;
    font-size: 13px;
  }
  
  .user-email {
    max-width: 120px;
  }
  
  .dropdown-menu {
    min-width: 140px;
  }

  .header-nav {
    padding: 8px 15px;
  }

  .nav-container {
    gap: 15px;
  }

  .nav-link {
    padding: 6px 10px;
    font-size: 12px;
  }

  .nav-icon {
    width: 18px;
    height: 18px;
  }
}

@media (max-width: 480px) {
  .auth-icon-container {
    top: 10px;
    right: 10px;
  }
  
  .login-link,
  .profile-dropdown {
    padding: 6px 10px;
    font-size: 12px;
  }
  
  .user-email {
    max-width: 100px;
  }
  
  .dropdown-menu {
    min-width: 120px;
  }

  .header-nav {
    padding: 6px 10px;
  }

  .nav-container {
    gap: 10px;
  }

  .nav-link {
    padding: 5px 8px;
    font-size: 11px;
  }

  .nav-icon {
    width: 16px;
    height: 16px;
  }
}
</style> 