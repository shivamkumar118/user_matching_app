<template>
  <div class="modal-overlay" @click="$emit('close')">
    <div class="modal-content" @click.stop>
      <div class="modal-header">
        <h3>Edit Personal Information</h3>
        <button class="close-button" @click="$emit('close')">×</button>
      </div>
      
      <form @submit.prevent="handleSubmit" class="modal-form">
        <div class="form-row">
          <div class="form-group">
            <label>First Name</label>
            <input 
              v-model="form.first_name"
              type="text" 
              required
              placeholder="First name"
            >
          </div>
          <div class="form-group">
            <label>Last Name</label>
            <input 
              v-model="form.last_name"
              type="text" 
              required
              placeholder="Last name"
            >
          </div>
        </div>
        
        <div class="form-group">
          <label>Email</label>
          <input 
            v-model="form.email"
            type="email" 
            required
            placeholder="Email address"
          >
        </div>
        
        <div class="form-group">
          <label>Phone</label>
          <input 
            v-model="form.phone"
            type="tel" 
            placeholder="Phone number (optional)"
          >
        </div>
        
        <div class="form-group">
          <label>Address</label>
          <input 
            v-model="form.address"
            type="text" 
            placeholder="Address (optional)"
          >
        </div>
        
        <div class="form-group">
          <label>Employment Status</label>
          <select v-model="form.employment_status" class="employment-select">
            <option value="">Select employment status</option>
            <option value="employed">💼 Employed</option>
            <option value="unemployed">🔍 Unemployed</option>
            <option value="freelancer">🚀 Freelancer</option>
            <option value="student">🎓 Student</option>
            <option value="retired">🌅 Retired</option>
          </select>
        </div>
        
        <div class="modal-actions">
          <button type="button" class="cancel-button" @click="$emit('close')">
            Cancel
          </button>
          <button type="submit" class="save-button" :disabled="loading">
            {{ loading ? 'Saving...' : 'Save Changes' }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'

const props = defineProps({
  profile: {
    type: Object,
    default: () => ({})
  }
})

const emit = defineEmits(['close', 'save'])

const loading = ref(false)

const form = reactive({
  first_name: '',
  last_name: '',
  email: '',
  phone: '',
  address: '',
  employment_status: ''
})

onMounted(() => {
  if (props.profile) {
    Object.assign(form, {
      first_name: props.profile.first_name || '',
      last_name: props.profile.last_name || '',
      email: props.profile.email || '',
      phone: props.profile.phone || '',
      address: props.profile.address || '',
      employment_status: props.profile.employment_status || ''
    })
  }
})

const handleSubmit = async () => {
  loading.value = true
  try {
    await emit('save', { ...form })
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
  max-width: 500px;
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
  flex-wrap: wrap;
}

.form-row .form-group {
  flex: 1;
  min-width: 200px;
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
.form-group select {
  width: 100%;
  padding: 12px 15px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 10px;
  color: white;
  font-size: 1rem;
  transition: all 0.3s ease;
  box-sizing: border-box;
}

.form-group input::placeholder {
  color: rgba(255, 255, 255, 0.5);
}

.form-group input:focus,
.form-group select:focus {
  outline: none;
  border-color: rgba(255, 255, 255, 0.5);
  background: rgba(255, 255, 255, 0.15);
}

.employment-select {
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.15), rgba(255, 255, 255, 0.05));
  border: 2px solid rgba(255, 255, 255, 0.3);
  color: white;
  font-weight: 500;
  position: relative;
  cursor: pointer;
}

.employment-select:hover {
  border-color: rgba(255, 255, 255, 0.5);
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.2), rgba(255, 255, 255, 0.1));
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
}

.employment-select:focus {
  border-color: #4ecdc4;
  background: linear-gradient(135deg, rgba(78, 205, 196, 0.2), rgba(255, 255, 255, 0.1));
  box-shadow: 0 0 0 3px rgba(78, 205, 196, 0.3);
}

/* Fix for dropdown options visibility */
.employment-select option {
  background-color: #2c3e50 !important;
  color: white !important;
  padding: 12px !important;
  font-weight: 500 !important;
  border: none !important;
}

.employment-select option:hover,
.employment-select option:focus {
  background-color: #4ecdc4 !important;
  color: white !important;
}

.employment-select option:checked {
  background-color: #4ecdc4 !important;
  color: white !important;
}

/* Additional fixes for different browsers */
.employment-select::-ms-expand {
  display: none;
}

.employment-select {
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
  background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='white'%3e%3cpath d='M7 10l5 5 5-5z'/%3e%3c/svg%3e");
  background-repeat: no-repeat;
  background-position: right 12px center;
  background-size: 20px;
  padding-right: 40px;
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
  
  .form-row .form-group {
    min-width: auto;
  }
  
  .modal-actions {
    flex-direction: column;
  }
}

@media (max-width: 480px) {
  .modal-content {
    max-width: 100%;
    margin: 10px;
  }
  
  .modal-form {
    padding: 20px;
  }
}
</style> 