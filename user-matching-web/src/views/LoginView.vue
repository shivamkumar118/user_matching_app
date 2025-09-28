<template>
  <BaseLayout>
    <!-- Content Container - Centers Everything -->
    <div class="content-container">
      <!-- Header Container -->
      <div class="header-container">
        <h1 class="main-title">User Matching</h1>
        <p class="subtitle">WELCOME BACK / JOIN US</p>
      </div>

      <!-- Glassmorphism Card -->
      <div class="glass-card">
        <transition name="form-transition" mode="out-in">
          <!-- Login Form -->
          <div v-if="!isSignup" key="login">
            <h2 class="card-title">Welcome Back</h2>
            
            <form @submit.prevent="handleLogin">
              <div class="form-group">
                <input 
                  v-model="form.email"
                  type="email" 
                  class="form-input" 
                  placeholder="Email address"
                  required
                >
                <div v-if="errors.email" class="error-message">{{ errors.email }}</div>
              </div>
              
              <div class="form-group">
                <input 
                  v-model="form.password"
                  type="password" 
                  class="form-input" 
                  placeholder="Password"
                  required
                >
                <div v-if="errors.password" class="error-message">{{ errors.password }}</div>
              </div>

              <!-- Remember Me -->
              <div class="checkbox-group">
                <div 
                  class="checkbox"
                  :class="{ checked: form.rememberMe }"
                  @click="form.rememberMe = !form.rememberMe"
                ></div>
                <label class="checkbox-label" @click="form.rememberMe = !form.rememberMe">
                  Remember me
                </label>
              </div>

              <!-- Error Message -->
              <div v-if="authStore.error" class="error-message text-center">
                {{ authStore.error }}
              </div>
              
              <button type="submit" class="auth-button" :disabled="authStore.loading">
                <span v-if="authStore.loading">Signing in...</span>
                <span v-else>Sign In</span>
              </button>
            </form>

            <!-- Toggle to Signup -->
            <div class="toggle-section">
              <p class="toggle-text">New to User Matching?</p>
              <button class="toggle-button" @click="toggleForm">
                Create Account
              </button>
            </div>
          </div>

          <!-- Signup Form -->
          <div v-else key="signup">
            <h2 class="card-title">Join Our Community</h2>
            
            <form @submit.prevent="handleSignup">
              <div class="form-row">
                <div class="form-group">
                  <input 
                    v-model="signupForm.first_name"
                    type="text" 
                    class="form-input" 
                    placeholder="First name"
                    required
                  >
                  <div v-if="signupErrors.first_name" class="error-message">{{ signupErrors.first_name }}</div>
                </div>
                
                <div class="form-group">
                  <input 
                    v-model="signupForm.last_name"
                    type="text" 
                    class="form-input" 
                    placeholder="Last name"
                    required
                  >
                  <div v-if="signupErrors.last_name" class="error-message">{{ signupErrors.last_name }}</div>
                </div>
              </div>
              
              <div class="form-group">
                <input 
                  v-model="signupForm.email"
                  type="email" 
                  class="form-input" 
                  placeholder="Email address"
                  required
                >
                <div v-if="signupErrors.email" class="error-message">{{ signupErrors.email }}</div>
              </div>
              
              <div class="form-group">
                <input 
                  v-model="signupForm.phone"
                  type="tel" 
                  class="form-input" 
                  placeholder="Phone number (optional)"
                >
                <div v-if="signupErrors.phone" class="error-message">{{ signupErrors.phone }}</div>
              </div>
              
              <div class="form-group">
                <select 
                  v-model="signupForm.employment_status"
                  class="form-input employment-select"
                >
                  <option value="">Employment status (optional)</option>
                  <option value="employed">💼 Employed</option>
                  <option value="unemployed">🔍 Unemployed</option>
                  <option value="freelancer">🆓 Freelancer</option>
                  <option value="student">🎓 Student</option>
                  <option value="retired">🏖️ Retired</option>
                </select>
                <div v-if="signupErrors.employment_status" class="error-message">{{ signupErrors.employment_status }}</div>
              </div>
              
              <div class="form-group">
                <input 
                  v-model="signupForm.password"
                  type="password" 
                  class="form-input" 
                  placeholder="Password"
                  required
                >
                <div v-if="signupErrors.password" class="error-message">{{ signupErrors.password }}</div>
              </div>

              <div class="form-group">
                <input 
                  v-model="signupForm.confirmPassword"
                  type="password" 
                  class="form-input" 
                  placeholder="Confirm password"
                  required
                >
                <div v-if="signupErrors.confirmPassword" class="error-message">{{ signupErrors.confirmPassword }}</div>
              </div>

              <!-- Remember Me -->
              <div class="checkbox-group">
                <div 
                  class="checkbox"
                  :class="{ checked: signupForm.rememberMe }"
                  @click="signupForm.rememberMe = !signupForm.rememberMe"
                ></div>
                <label class="checkbox-label" @click="signupForm.rememberMe = !signupForm.rememberMe">
                  Remember me
                </label>
              </div>
              
              <button type="submit" class="auth-button" :disabled="authStore.loading">
                <span v-if="authStore.loading">Creating account...</span>
                <span v-else>Create Account</span>
              </button>
            </form>

            <!-- Toggle to Login -->
            <div class="toggle-section">
              <p class="toggle-text">Already a member?</p>
              <button class="toggle-button" @click="toggleForm">
                Sign In
              </button>
            </div>
          </div>
        </transition>
      </div>
    </div>
  </BaseLayout>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import BaseLayout from '@/components/layouts/BaseLayout.vue'

const router = useRouter()
const authStore = useAuthStore()

const isSignup = ref(false)

const form = reactive({
  email: '',
  password: '',
  rememberMe: false
})

const signupForm = reactive({
  first_name: '',
  last_name: '',
  email: '',
  phone: '',
  employment_status: '',
  password: '',
  confirmPassword: '',
  rememberMe: false
})

const errors = reactive({
  email: '',
  password: ''
})

const signupErrors = reactive({
  first_name: '',
  last_name: '',
  email: '',
  phone: '',
  employment_status: '',
  password: '',
  confirmPassword: ''
})

const validateEmail = (email) => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  return emailRegex.test(email)
}

const validatePassword = (password) => {
  return password.length >= 6
}

const validateForm = () => {
  errors.email = ''
  errors.password = ''
  
  if (!validateEmail(form.email)) {
    errors.email = 'Please enter a valid email address'
    return false
  }
  
  if (!validatePassword(form.password)) {
    errors.password = 'Password must be at least 6 characters'
    return false
  }
  
  return true
}

const validateSignupForm = () => {
  signupErrors.first_name = ''
  signupErrors.last_name = ''
  signupErrors.email = ''
  signupErrors.phone = ''
  signupErrors.employment_status = ''
  signupErrors.password = ''
  signupErrors.confirmPassword = ''
  
  if (!signupForm.first_name) {
    signupErrors.first_name = 'First name is required'
    return false
  }
  if (signupForm.first_name.length < 2) {
    signupErrors.first_name = 'First name must be at least 2 characters'
    return false
  }
  if (signupForm.first_name.length > 50) {
    signupErrors.first_name = 'First name must be less than 50 characters'
    return false
  }
  
  if (!signupForm.last_name) {
    signupErrors.last_name = 'Last name is required'
    return false
  }
  if (signupForm.last_name.length < 2) {
    signupErrors.last_name = 'Last name must be at least 2 characters'
    return false
  }
  if (signupForm.last_name.length > 50) {
    signupErrors.last_name = 'Last name must be less than 50 characters'
    return false
  }
  
  if (!validateEmail(signupForm.email)) {
    signupErrors.email = 'Please enter a valid email address'
    return false
  }
  
  if (!validatePassword(signupForm.password)) {
    signupErrors.password = 'Password must be at least 6 characters'
    return false
  }
  
  if (signupForm.password !== signupForm.confirmPassword) {
    signupErrors.confirmPassword = 'Passwords do not match'
    return false
  }
  
  return true
}

const handleLogin = async () => {
  if (!validateForm()) return
  
  try {
    await authStore.login({
      email: form.email,
      password: form.password
    })
    router.push('/dashboard')
  } catch (error) {
    console.error('Login failed:', error)
  }
}

const handleSignup = async () => {
  if (!validateSignupForm()) return
  
  try {
    await authStore.register({
      first_name: signupForm.first_name,
      last_name: signupForm.last_name,
      email: signupForm.email,
      phone: signupForm.phone,
      employment_status: signupForm.employment_status,
      password: signupForm.password,
      password_confirmation: signupForm.confirmPassword
    })
    router.push('/dashboard')
  } catch (error) {
    console.error('Signup failed:', error)
  }
}

const toggleForm = () => {
  isSignup.value = !isSignup.value
  
  // Reset forms and errors when switching
  Object.assign(form, { email: '', password: '', rememberMe: false })
  Object.assign(signupForm, {
    first_name: '',
    last_name: '',
    email: '',
    phone: '',
    employment_status: '',
    password: '',
    confirmPassword: '',
    rememberMe: false
  })
  Object.assign(errors, { email: '', password: '' })
  Object.assign(signupErrors, {
    first_name: '',
    last_name: '',
    email: '',
    phone: '',
    employment_status: '',
    password: '',
    confirmPassword: ''
  })
}
</script>

<style scoped>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
  font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Helvetica Neue', Arial, sans-serif;
}

/* Content Container - Centers Everything */
.content-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  z-index: 10;
  position: relative;
  width: 100%;s
  max-width: 400px;
  padding: 0 20px;
}

/* Header Container */
.header-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  margin-bottom: 20px;
  text-align: center;
  animation: fadeInDown 1s ease-out;
}

.main-title {
  font-size: 3rem;
  font-weight: 700;
  color: white;
  margin-bottom: 8px;
  background: linear-gradient(135deg, #ff6b6b, #ffd93d, #4ecdc4);
  background-clip: text;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  text-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
  animation: titleGlow 2s ease-in-out infinite alternate;
}

.subtitle {
  font-size: 1.1rem;
  color: rgba(255, 255, 255, 0.8);
  font-weight: 400;
  letter-spacing: 2px;
  text-transform: uppercase;
  opacity: 0;
  animation: fadeInUp 1s ease-out 0.3s forwards;
}

@keyframes titleGlow {
  0% { filter: brightness(1); }
  100% { filter: brightness(1.2); }
}

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

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Glassmorphism Card */
.glass-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  border-radius: 20px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  padding: 40px;
  box-shadow: 0 25px 50px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
  width: 100%;
  max-width: 400px;
  opacity: 0;
  animation: slideInUp 1s ease-out 0.6s forwards;
}

.glass-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 35px 60px rgba(0, 0, 0, 0.15);
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

/* Card Content */
.card-title {
  font-size: 1.5rem;
  font-weight: 600;
  color: white;
  margin-bottom: 15px;
  text-align: center;
}

.form-group {
  margin-bottom: 20px;
}

.form-row {
  display: flex;
  gap: 20px;
  margin-bottom: 20px;
}

.form-row .form-group {
  flex: 1;
  margin-bottom: 0;
}

.form-input {
  width: 100%;
  padding: 15px 20px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 12px;
  color: white;
  font-size: 1rem;
  transition: all 0.3s ease;
  backdrop-filter: blur(10px);
}

.form-input::placeholder {
  color: rgba(255, 255, 255, 0.6);
}

.form-input:focus {
  outline: none;
  border-color: rgba(255, 255, 255, 0.5);
  background: rgba(255, 255, 255, 0.15);
  transform: translateY(-2px);
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
}

.auth-button {
  width: 100%;
  padding: 15px;
  background: linear-gradient(135deg, #ff6b6b, #ffd93d);
  border: none;
  border-radius: 12px;
  color: white;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  margin-top: 10px;
  position: relative;
  overflow: hidden;
}

.auth-button::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
  transition: left 0.5s;
}

.auth-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
}

.auth-button:hover::before {
  left: 100%;
}

.auth-button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  transform: none;
}

/* Checkbox Group */
.checkbox-group {
  display: flex;
  align-items: center;
  gap: 10px;
  margin: 20px 0;
}

.checkbox {
  width: 18px;
  height: 18px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.3);
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
}

.checkbox.checked {
  background: rgba(255, 255, 255, 0.3);
  border-color: rgba(255, 255, 255, 0.7);
}

.checkbox.checked::after {
  content: '✓';
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  color: white;
  font-size: 12px;
  font-weight: bold;
}

.checkbox-label {
  color: rgba(255, 255, 255, 0.8);
  font-size: 0.9rem;
  cursor: pointer;
  user-select: none;
}

/* Toggle Section */
.toggle-section {
  text-align: center;
  margin-top: 25px;
}

.toggle-text {
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.8rem;
  margin-bottom: 10px;
}

.toggle-button {
  background: none;
  border: 1px solid rgba(255, 255, 255, 0.3);
  color: rgba(255, 255, 255, 0.8);
  padding: 6px 16px;
  border-radius: 20px;
  cursor: pointer;
  font-size: 0.8rem;
  transition: all 0.3s ease;
}

.toggle-button:hover {
  border-color: rgba(255, 255, 255, 0.6);
  color: white;
  background: rgba(255, 255, 255, 0.1);
}

/* Form Transitions */
.form-transition-enter-active,
.form-transition-leave-active {
  transition: all 0.4s ease;
}

.form-transition-enter-from {
  opacity: 0;
  transform: translateX(30px);
}

.form-transition-leave-to {
  opacity: 0;
  transform: translateX(-30px);
}

/* Error Messages */
.error-message {
  color: #ff6b6b;
  font-size: 0.75rem;
  margin-top: 5px;
  animation: fadeIn 0.3s ease forwards;
}

@keyframes fadeIn {
  to { 
    opacity: 1; 
  }
}

/* Employment Status Dropdown Styling */
.employment-select {
  appearance: none;
  background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%23ffffff' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
  background-position: right 12px center;
  background-repeat: no-repeat;
  background-size: 16px;
  padding-right: 40px;
}

.employment-select option {
  background-color: #2c3e50 !important;
  color: #ffffff !important;
  padding: 12px 16px;
  font-size: 14px;
  border: none;
  outline: none;
}

.employment-select option:hover {
  background-color: #34495e !important;
}

.employment-select option:checked {
  background-color: #3498db !important;
}

.employment-select:focus {
  border-color: rgba(255, 255, 255, 0.7);
  background-color: rgba(255, 255, 255, 0.2);
  box-shadow: 0 0 0 3px rgba(255, 255, 255, 0.1);
}

/* Responsive Design */
@media (max-width: 768px) {
  .main-title {
    font-size: 2.5rem;
  }
  
  .subtitle {
    font-size: 1rem;
  }
  
  .glass-card {
    padding: 30px 25px;
    margin: 0 15px;
  }
  
  .content-container {
    max-width: 350px;
  }
  
  .form-row {
    flex-direction: column;
    gap: 0;
  }
  
  .form-row .form-group {
    margin-bottom: 20px;
  }
}

@media (max-width: 480px) {
  .main-title {
    font-size: 2rem;
  }
  
  .subtitle {
    font-size: 0.9rem;
    letter-spacing: 1px;
  }
  
  .glass-card {
    padding: 25px 20px;
  }
}
</style>