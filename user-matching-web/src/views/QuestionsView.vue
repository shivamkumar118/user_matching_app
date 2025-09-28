<template>
  <BaseLayout>
    <div class="questions-container">
      <!-- Header -->
      <div class="questions-header">
        <h1 class="questions-title">Answer Questions</h1>
        <p class="questions-subtitle">Help others understand you better and find better matches</p>
      </div>

      <!-- Loading State -->
      <div v-if="userStore.loading" class="loading-container">
        <div class="loading-spinner"></div>
        <p>Loading questions...</p>
      </div>

      <!-- Error State -->
      <div v-else-if="userStore.error" class="error-container">
        <p class="error-message">{{ userStore.error }}</p>
        <button @click="loadQuestionsData" class="retry-button">Retry</button>
      </div>

      <!-- Content -->
      <div v-else>
        <!-- Progress Section -->
        <div class="progress-section">
          <div class="progress-card">
            <div class="progress-info">
              <h3>Your Progress</h3>
              <p>{{ userStore.answeredQuestionsCount }} of {{ userStore.totalQuestionsCount }} questions answered</p>
            </div>
            <div class="progress-bar">
              <div class="progress-fill" :style="{ width: userStore.questionsProgressPercentage + '%' }"></div>
            </div>
            <span class="progress-percentage">{{ userStore.questionsProgressPercentage }}%</span>
          </div>
        </div>

        <!-- Questions Section -->
        <div class="questions-section">
          <h2 class="section-title">Questions</h2>
          
          <!-- Empty State -->
          <div v-if="userStore.questions.length === 0" class="empty-state">
            <p>No questions available at the moment.</p>
          </div>
          
          <!-- Questions List -->
          <div v-else class="questions-list">
            <div 
              class="question-card" 
              v-for="question in questionsWithAnswers" 
              :key="question.id"
              :class="{ answered: question.answered }"
            >
              <div class="question-header">
                <div class="question-number">Q{{ question.id }}</div>
                <div class="question-category">{{ formatCategory(question.category) }}</div>
              </div>
              
              <h3 class="question-text">{{ question.title }}</h3>
              
              <div class="answer-section">
                <textarea 
                  v-model="question.answer"
                  :placeholder="question.answered ? 'Your answer (minimum 5 characters)...' : 'Click to answer (minimum 5 characters)...'"
                  class="answer-input"
                  rows="3"
                  @focus="question.answered = true"
                  maxlength="500"
                  @keydown.ctrl.enter="saveAnswer(question)"
                ></textarea>
                
                <div class="answer-actions">
                  <button 
                    type="button"
                    class="save-btn"
                    :class="{ active: question.answer.trim() && question.answer.trim().length >= 5 }"
                    :disabled="false"
                    @click="saveAnswer(question)"
                    @mousedown="console.log('Button state:', { 
                      loading: userStore.loading, 
                      hasAnswer: !!question.answer.trim(), 
                      answerLength: question.answer.trim().length,
                      isDisabled: userStore.loading || !question.answer.trim() || question.answer.trim().length < 5
                    })"
                  >
                    {{ userStore.loading ? 'Saving...' : (question.answered ? 'Update' : 'Save') }}
                  </button>
                  
                  <div class="character-count" :class="{ 'error': question.answer.length > 0 && question.answer.length < 5 }">
                    {{ question.answer.length }}/500
                    <span v-if="question.answer.length > 0 && question.answer.length < 5" class="min-length-warning">
                      (min 5)
                    </span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Tips Section -->
        <div class="tips-section">
          <div class="tips-card">
            <h3>💡 Tips for Better Answers</h3>
            <ul>
              <li>Be honest and authentic in your responses</li>
              <li>Provide specific examples when possible</li>
              <li>Think about how your answers reflect your values</li>
              <li>Consider how your responses might help others understand you</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </BaseLayout>
</template>

<script setup>
import { onMounted, computed } from 'vue'
import { useUserStore } from '@/stores/user'
import BaseLayout from '@/components/layouts/BaseLayout.vue'

const userStore = useUserStore()

// Computed property to ensure reactivity
const questionsWithAnswers = computed(() => {
  return userStore.questionsWithAnswers
})

onMounted(() => {
  console.log('QuestionsView mounted, initial store state:', {
    questions: userStore.questions,
    answers: userStore.answers,
    loading: userStore.loading,
    error: userStore.error
  })
  
  // Check authentication
  const authToken = localStorage.getItem('authToken')
  console.log('Auth token present:', !!authToken)
  
  loadQuestionsData()
})

const loadQuestionsData = async () => {
  try {
    console.log('Loading questions data...') // Debug log
    await userStore.loadQuestionsData()
    console.log('Questions data loaded, store state:', {
      questions: userStore.questions,
      answers: userStore.answers,
      questionsWithAnswers: userStore.questionsWithAnswers
    }) // Debug log
  } catch (error) {
    console.error('Failed to load questions data:', error)
  }
}

const formatCategory = (category) => {
  return category.charAt(0).toUpperCase() + category.slice(1)
}

const saveAnswer = async (question) => {
  console.log('Save button clicked for question:', question) // Debug log
  
  if (!question.answer.trim()) {
    console.log('Answer is empty, returning early') // Debug log
    return
  }

  // Frontend validation to match backend requirements
  if (question.answer.trim().length < 5) {
    console.log('Answer too short, setting error') // Debug log
    userStore.error = 'Answer must be at least 5 characters long.'
    return
  }

  console.log('Proceeding with save, answer data:', {
    question_id: question.id,
    answer_text: question.answer.trim(),
    has_answer_id: !!question.answer_id
  }) // Debug log

  try {
    const answerData = {
      question_id: question.id,
      answer_text: question.answer.trim()
    }

    if (question.answer_id) {
      // Update existing answer
      console.log('Updating existing answer with ID:', question.answer_id) // Debug log
      await userStore.updateAnswer(question.answer_id, answerData)
    } else {
      // Create new answer
      console.log('Creating new answer') // Debug log
      await userStore.createAnswer(answerData)
    }
    
    // Clear any previous errors
    userStore.clearError()
    console.log('Answer saved successfully') // Debug log
  } catch (error) {
    console.error('Failed to save answer:', error)
    // Error message is already set in the store
  }
}
</script>

<style scoped>
.questions-container {
  width: 100%;
  max-width: 800px;
  padding: 20px;
  margin: 0 auto;
}

/* Header */
.questions-header {
  text-align: center;
  margin-bottom: 40px;
  animation: fadeInDown 1s ease-out;
}

.questions-title {
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

.questions-subtitle {
  font-size: 1.2rem;
  color: rgba(255, 255, 255, 0.8);
  font-weight: 400;
}

/* Progress Section */
.progress-section {
  margin-bottom: 40px;
}

.progress-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  border-radius: 20px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  padding: 25px;
  animation: slideInUp 1s ease-out 0.2s forwards;
  opacity: 0;
}

.progress-info {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.progress-info h3 {
  color: white;
  font-size: 1.3rem;
  font-weight: 600;
}

.progress-info p {
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.9rem;
}

.progress-bar {
  width: 100%;
  height: 12px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 6px;
  margin-bottom: 10px;
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  background: linear-gradient(90deg, #4ecdc4, #44a08d);
  border-radius: 6px;
  transition: width 0.5s ease;
}

.progress-percentage {
  color: #4ecdc4;
  font-weight: 700;
  font-size: 1.1rem;
}

/* Questions Section */
.questions-section {
  margin-bottom: 40px;
}

.section-title {
  font-size: 1.8rem;
  font-weight: 600;
  color: white;
  margin-bottom: 20px;
  text-align: center;
}

.questions-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.question-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  border-radius: 20px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  padding: 25px;
  transition: all 0.3s ease;
  animation: slideInUp 1s ease-out 0.4s forwards;
  opacity: 0;
}

.question-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
}

.question-card.answered {
  border-color: rgba(78, 205, 196, 0.5);
  background: rgba(255, 255, 255, 0.15);
}

.question-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.question-number {
  background: linear-gradient(135deg, #ff6b6b, #ffd93d);
  color: white;
  padding: 8px 16px;
  border-radius: 20px;
  font-weight: 600;
  font-size: 0.9rem;
}

.question-category {
  color: rgba(255, 255, 255, 0.6);
  font-size: 0.8rem;
  text-transform: uppercase;
  letter-spacing: 1px;
  font-weight: 500;
}

.question-text {
  color: white;
  font-size: 1.2rem;
  font-weight: 600;
  margin-bottom: 20px;
  line-height: 1.4;
}

.answer-section {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.answer-input {
  width: 100%;
  padding: 15px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 12px;
  color: white;
  font-size: 1rem;
  resize: vertical;
  transition: all 0.3s ease;
  font-family: inherit;
  box-sizing: border-box;
}

.answer-input::placeholder {
  color: rgba(255, 255, 255, 0.5);
}

.answer-input:focus {
  outline: none;
  border-color: rgba(78, 205, 196, 0.8);
  background: rgba(255, 255, 255, 0.15);
}

.answer-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.save-btn {
  padding: 10px 20px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.3);
  border-radius: 20px;
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.9rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
}

.save-btn.active {
  background: linear-gradient(135deg, #4ecdc4, #44a08d);
  border-color: transparent;
  color: white;
}

.save-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
}

.character-count {
  color: rgba(255, 255, 255, 0.5);
  font-size: 0.8rem;
}

.character-count.error {
  color: #ff6b6b;
  font-weight: 600;
}

.min-length-warning {
  color: #ffd93d;
  font-weight: 600;
  margin-left: 5px;
}

/* Loading and Error States */
.loading-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  text-align: center;
}

.loading-spinner {
  width: 40px;
  height: 40px;
  border: 4px solid rgba(255, 255, 255, 0.1);
  border-left: 4px solid #4ecdc4;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 20px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.loading-container p {
  color: rgba(255, 255, 255, 0.8);
  font-size: 1.1rem;
}

.error-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  text-align: center;
}

.error-message {
  color: #ff6b6b;
  font-size: 1.1rem;
  margin-bottom: 20px;
  background: rgba(255, 107, 107, 0.1);
  padding: 15px 20px;
  border-radius: 10px;
  border: 1px solid rgba(255, 107, 107, 0.3);
}

.retry-button {
  background: linear-gradient(135deg, #4ecdc4, #44a08d);
  color: white;
  border: none;
  padding: 12px 24px;
  border-radius: 10px;
  font-size: 1rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
}

.retry-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
}

.empty-state {
  text-align: center;
  padding: 60px 20px;
  color: rgba(255, 255, 255, 0.7);
  font-size: 1.1rem;
}

/* Tips Section */
.tips-section {
  margin-bottom: 40px;
}

.tips-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  border-radius: 20px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  padding: 25px;
  animation: slideInUp 1s ease-out 0.6s forwards;
  opacity: 0;
}

.tips-card h3 {
  color: white;
  font-size: 1.3rem;
  font-weight: 600;
  margin-bottom: 15px;
}

.tips-card ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.tips-card li {
  color: rgba(255, 255, 255, 0.8);
  font-size: 1rem;
  margin-bottom: 10px;
  padding-left: 20px;
  position: relative;
}

.tips-card li:before {
  content: "•";
  color: #4ecdc4;
  font-weight: bold;
  position: absolute;
  left: 0;
}

.tips-card li:last-child {
  margin-bottom: 0;
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
  .questions-container {
    padding: 15px;
  }
  
  .questions-title {
    font-size: 2.5rem;
  }
  
  .tips-grid {
    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
  }
  
  .progress-info {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }
}

@media (max-width: 480px) {
  .questions-title {
    font-size: 2rem;
  }
  
  .question-card {
    padding: 20px;
  }
  
  .question-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }
  
  .answer-actions {
    flex-direction: column;
    gap: 10px;
    align-items: stretch;
  }
}
</style> 