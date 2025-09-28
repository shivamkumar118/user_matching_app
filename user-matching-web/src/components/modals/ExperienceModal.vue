<template>
  <div class="modal-overlay" @click="$emit('close')">
    <div class="modal-content" @click.stop>
      <div class="modal-header">
        <h3>{{ experience ? 'Edit Experience' : 'Add Experience' }}</h3>
        <button class="close-button" @click="$emit('close')">×</button>
      </div>
      
      <form @submit.prevent="handleSubmit" class="modal-form">
        <div class="form-group">
          <label>Job Title</label>
          <input 
            v-model="form.job_title"
            type="text" 
            required
            placeholder="e.g., Senior Software Engineer"
          >
        </div>
        
        <div class="form-group">
          <label>Company Name</label>
          <input 
            v-model="form.company_name"
            type="text" 
            required
            placeholder="e.g., TechCorp Inc."
          >
        </div>
        
        <div class="form-row">
          <div class="form-group">
            <label>Start Date</label>
            <input 
              v-model="form.start_date"
              type="text" 
              required
              class="date-input"
              placeholder="DD/MM/YYYY"
              @blur="formatStartDate"
              @input="validateDateInput"
            >
          </div>
          <div class="form-group">
            <label>End Date</label>
            <input 
              v-model="form.end_date"
              type="text"
              class="date-input"
              placeholder="DD/MM/YYYY"
              @blur="formatEndDate"
              @input="validateDateInput"
              :disabled="isCurrentJob"
            >
            <div class="checkbox-group">
              <input 
                id="current-job"
                v-model="isCurrentJob"
                type="checkbox"
                @change="handleCurrentJobChange"
                class="custom-checkbox"
              >
              <label for="current-job">Current job</label>
            </div>
          </div>
        </div>
        
        <div class="form-group">
          <label>Description</label>
          <textarea 
            v-model="form.description"
            rows="4"
            placeholder="Describe your role, responsibilities, and achievements..."
            required
          ></textarea>
        </div>
        
        <div class="modal-actions">
          <button type="button" class="cancel-button" @click="$emit('close')">
            Cancel
          </button>
          <button type="submit" class="save-button" :disabled="loading">
            {{ loading ? 'Saving...' : (experience ? 'Update Experience' : 'Add Experience') }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue'

const props = defineProps({
  experience: {
    type: Object,
    default: null
  }
})

const emit = defineEmits(['close', 'save'])

const loading = ref(false)
const isCurrentJob = ref(false)

const form = reactive({
  job_title: '',
  company_name: '',
  start_date: '',
  end_date: '',
  description: ''
})

const today = computed(() => {
  const today = new Date()
  const day = String(today.getDate()).padStart(2, '0')
  const month = String(today.getMonth() + 1).padStart(2, '0')
  const year = today.getFullYear()
  return `${day}-${month}-${year}`
})

onMounted(() => {
  if (props.experience) {
    Object.assign(form, {
      job_title: props.experience.job_title || '',
      company_name: props.experience.company_name || '',
      start_date: props.experience.start_date ? formatDateForDisplay(props.experience.start_date) : '',
      end_date: props.experience.end_date ? formatDateForDisplay(props.experience.end_date) : '',
      description: props.experience.description || ''
    })
    isCurrentJob.value = !props.experience.end_date
  }
})

const formatDateForDisplay = (dateString) => {
  if (!dateString) return ''
  const date = new Date(dateString + 'T00:00:00') // Add time to prevent timezone issues
  if (isNaN(date.getTime())) return ''
  
  const day = String(date.getDate()).padStart(2, '0')
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const year = date.getFullYear()
  return `${day}/${month}/${year}`
}

const formatDateForAPI = (dateString) => {
  if (!dateString) return null
  
  // Handle DD/MM/YYYY format
  const parts = dateString.split('/')
  if (parts.length === 3) {
    const [day, month, year] = parts
    // Create date in local timezone to avoid timezone conversion issues
    const date = new Date(parseInt(year), parseInt(month) - 1, parseInt(day))
    if (!isNaN(date.getTime())) {
      // Format as YYYY-MM-DD without timezone conversion
      const year = date.getFullYear()
      const month = String(date.getMonth() + 1).padStart(2, '0')
      const day = String(date.getDate()).padStart(2, '0')
      return `${year}-${month}-${day}`
    }
  }
  
  // Handle DD-MM-YYYY format (fallback)
  const dashParts = dateString.split('-')
  if (dashParts.length === 3) {
    const [day, month, year] = dashParts
    const date = new Date(parseInt(year), parseInt(month) - 1, parseInt(day))
    if (!isNaN(date.getTime())) {
      const year = date.getFullYear()
      const month = String(date.getMonth() + 1).padStart(2, '0')
      const day = String(date.getDate()).padStart(2, '0')
      return `${year}-${month}-${day}`
    }
  }
  
  // Handle YYYY-MM-DD format (fallback)
  const date = new Date(dateString + 'T00:00:00')
  if (!isNaN(date.getTime())) {
    const year = date.getFullYear()
    const month = String(date.getMonth() + 1).padStart(2, '0')
    const day = String(date.getDate()).padStart(2, '0')
    return `${year}-${month}-${day}`
  }
  
  return null
}

const validateDateInput = (event) => {
  let value = event.target.value
  
  // Only allow numbers and forward slashes
  value = value.replace(/[^0-9/]/g, '')
  
  // Get cursor position and previous value
  const cursorPosition = event.target.selectionStart
  const previousValue = event.target.dataset.previousValue || ''
  
  // Check if user is deleting (value is shorter than previous)
  const isDeleting = value.length < previousValue.replace(/[^0-9/]/g, '').length
  
  // Only auto-format if not deleting
  if (!isDeleting) {
    // Simple auto-formatting: add slashes after 2 and 5 digits
    if (value.length >= 2 && !value.includes('/')) {
      value = value.slice(0, 2) + '/' + value.slice(2)
    }
    if (value.length >= 5 && value.split('/').length === 2) {
      const parts = value.split('/')
      if (parts[1].length >= 2) {
        value = parts[0] + '/' + parts[1].slice(0, 2) + '/' + parts[1].slice(2)
      }
    }
  }
  
  // Limit to reasonable length (DD/MM/YYYY = 10 chars)
  if (value.length > 10) {
    value = value.slice(0, 10)
  }
  
  event.target.value = value
  
  // Store current value for next comparison
  event.target.dataset.previousValue = value
  
  // Restore cursor position after formatting
  setTimeout(() => {
    let newPosition = cursorPosition
    // Adjust cursor position if slashes were added and not deleting
    if (!isDeleting && value.length > cursorPosition && value[cursorPosition] === '/') {
      newPosition = cursorPosition + 1
    }
    if (newPosition <= value.length) {
      event.target.setSelectionRange(newPosition, newPosition)
    }
  }, 0)
}

const formatStartDate = () => {
  if (form.start_date) {
    // Try to format if it's a complete date, otherwise leave as is
    if (form.start_date.length === 10) {
      const formatted = formatDateForAPI(form.start_date)
      if (formatted) {
        form.start_date = formatDateForDisplay(formatted)
      }
    }
  }
}

const formatEndDate = () => {
  if (form.end_date) {
    // Try to format if it's a complete date, otherwise leave as is
    if (form.end_date.length === 10) {
      const formatted = formatDateForAPI(form.end_date)
      if (formatted) {
        form.end_date = formatDateForDisplay(formatted)
      }
    }
  }
}

const handleCurrentJobChange = () => {
  if (isCurrentJob.value) {
    form.end_date = ''
  }
}

const handleSubmit = async () => {
  loading.value = true
  try {
    const data = { ...form }
    
    // Convert dates to API format, but be more flexible
    data.start_date = formatDateForAPI(form.start_date)
    if (!data.start_date) {
      alert('Please enter a valid start date in DD/MM/YYYY format')
      loading.value = false
      return
    }
    
    if (isCurrentJob.value) {
      data.end_date = null // Explicitly set to null for current job
    } else {
      data.end_date = formatDateForAPI(form.end_date) || null
      // Only validate end date if it's provided
      if (form.end_date && !data.end_date) {
        alert('Please enter a valid end date in DD/MM/YYYY format')
        loading.value = false
        return
      }
    }
    
    await emit('save', data)
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.7);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: 20px;
}

.modal-content {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  border-radius: 20px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  width: 100%;
  max-width: 600px;
  max-height: 90vh;
  overflow-y: auto;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 25px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
}

.modal-header h3 {
  color: white;
  font-size: 1.3rem;
  font-weight: 600;
  margin: 0;
}

.close-button {
  background: none;
  border: none;
  color: rgba(255, 255, 255, 0.7);
  font-size: 1.5rem;
  cursor: pointer;
  padding: 0;
  width: 30px;
  height: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: all 0.3s ease;
}

.close-button:hover {
  background: rgba(255, 255, 255, 0.1);
  color: white;
}

.modal-form {
  padding: 25px;
}

.form-row {
  display: flex;
  gap: 15px;
  margin-bottom: 20px;
}

.form-row .form-group {
  flex: 1;
}

.form-group {
  margin-bottom: 20px;
}

.form-group label {
  display: block;
  color: rgba(255, 255, 255, 0.8);
  font-size: 0.9rem;
  font-weight: 500;
  margin-bottom: 8px;
}

.form-group input,
.form-group textarea {
  width: 100%;
  padding: 12px 15px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 10px;
  color: white;
  font-size: 1rem;
  font-family: inherit;
  transition: all 0.3s ease;
  box-sizing: border-box;
}

.form-group input::placeholder,
.form-group textarea::placeholder {
  color: rgba(255, 255, 255, 0.5);
}

.form-group input:focus,
.form-group textarea:focus {
  outline: none;
  border-color: rgba(255, 255, 255, 0.5);
  background: rgba(255, 255, 255, 0.15);
}

.date-input {
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.15), rgba(255, 255, 255, 0.05));
  border: 2px solid rgba(255, 255, 255, 0.3);
  color: white;
  font-weight: 500;
  position: relative;
  cursor: pointer;
}

.date-input:hover {
  border-color: rgba(255, 255, 255, 0.5);
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.2), rgba(255, 255, 255, 0.1));
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
}

.date-input:focus {
  border-color: #4ecdc4;
  background: linear-gradient(135deg, rgba(78, 205, 196, 0.2), rgba(255, 255, 255, 0.1));
  box-shadow: 0 0 0 3px rgba(78, 205, 196, 0.3);
}

.date-input:disabled {
  background: rgba(255, 255, 255, 0.05);
  border-color: rgba(255, 255, 255, 0.1);
  color: rgba(255, 255, 255, 0.4);
  cursor: not-allowed;
  opacity: 0.6;
}

.date-input:disabled:hover {
  transform: none;
  box-shadow: none;
  border-color: rgba(255, 255, 255, 0.1);
  background: rgba(255, 255, 255, 0.05);
}

/* Custom date input styling for webkit browsers */
.date-input::-webkit-calendar-picker-indicator {
  filter: invert(1);
  cursor: pointer;
  opacity: 0.7;
  transition: opacity 0.3s ease;
}

.date-input::-webkit-calendar-picker-indicator:hover {
  opacity: 1;
}

.form-group textarea {
  resize: vertical;
}

.checkbox-group {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-top: 8px;
}

.custom-checkbox {
  width: 18px !important;
  height: 18px !important;
  margin: 0 !important;
  accent-color: #4ecdc4;
  cursor: pointer;
  border-radius: 4px;
  border: 2px solid rgba(255, 255, 255, 0.3);
  background: rgba(255, 255, 255, 0.1);
  transition: all 0.3s ease;
}

.custom-checkbox:hover {
  border-color: rgba(255, 255, 255, 0.5);
  background: rgba(255, 255, 255, 0.15);
}

.custom-checkbox:checked {
  background: #4ecdc4;
  border-color: #4ecdc4;
}

.checkbox-group label {
  margin: 0;
  font-size: 0.9rem;
  color: rgba(255, 255, 255, 0.8);
  cursor: pointer;
  font-weight: 500;
  transition: color 0.3s ease;
}

.checkbox-group label:hover {
  color: white;
}

.modal-actions {
  display: flex;
  gap: 15px;
  justify-content: flex-end;
  margin-top: 30px;
}

.cancel-button,
.save-button {
  padding: 12px 24px;
  border-radius: 10px;
  font-size: 1rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
  border: none;
}

.cancel-button {
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.3);
  color: white;
}

.cancel-button:hover {
  background: rgba(255, 255, 255, 0.2);
  border-color: rgba(255, 255, 255, 0.5);
}

.save-button {
  background: linear-gradient(135deg, #4ecdc4, #44a08d);
  color: white;
}

.save-button:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
}

.save-button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  transform: none;
}

@media (max-width: 768px) {
  .modal-overlay {
    padding: 10px;
  }
  
  .form-row {
    flex-direction: column;
    gap: 0;
  }
  
  .modal-actions {
    flex-direction: column;
  }
}
</style> 