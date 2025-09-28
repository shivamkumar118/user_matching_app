<template>
  <div class="modal-overlay" @click="$emit('close')">
    <div class="modal-content" @click.stop>
      <div class="modal-header">
        <h3>Edit About Me</h3>
        <button class="close-button" @click="$emit('close')">×</button>
      </div>
      
      <form @submit.prevent="handleSubmit" class="modal-form">
        <div class="form-group">
          <label>Bio</label>
          <textarea 
            v-model="bio"
            rows="6"
            placeholder="Tell us about yourself, your interests, and what you're looking for..."
            maxlength="500"
            class="bio-textarea"
          ></textarea>
          <div class="character-count">{{ bio.length }}/500</div>
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
import { ref, onMounted } from 'vue'

const props = defineProps({
  bio: {
    type: String,
    default: ''
  }
})

const emit = defineEmits(['close', 'save'])

const loading = ref(false)
const bio = ref('')

onMounted(() => {
  bio.value = props.bio || ''
})

const handleSubmit = async () => {
  loading.value = true
  try {
    await emit('save', bio.value)
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

.form-group textarea {
  width: 100%;
  padding: 12px 15px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 10px;
  color: white;
  font-size: 1rem;
  font-family: inherit;
  resize: vertical;
  transition: all 0.3s ease;
  box-sizing: border-box;
}

.bio-textarea {
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.15), rgba(255, 255, 255, 0.05));
  border: 2px solid rgba(255, 255, 255, 0.3);
  color: white;
  font-weight: 500;
  min-height: 120px;
}

.bio-textarea:hover {
  border-color: rgba(255, 255, 255, 0.5);
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.2), rgba(255, 255, 255, 0.1));
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
}

.bio-textarea:focus {
  border-color: #4ecdc4;
  background: linear-gradient(135deg, rgba(78, 205, 196, 0.2), rgba(255, 255, 255, 0.1));
  box-shadow: 0 0 0 3px rgba(78, 205, 196, 0.3);
  outline: none;
}

.form-group textarea::placeholder {
  color: rgba(255, 255, 255, 0.5);
}

.form-group textarea:focus {
  outline: none;
  border-color: rgba(255, 255, 255, 0.5);
  background: rgba(255, 255, 255, 0.15);
}

.character-count {
  text-align: right;
  color: rgba(255, 255, 255, 0.5);
  font-size: 0.8rem;
  margin-top: 5px;
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
  
  .modal-actions {
    flex-direction: column;
  }
}
</style> 