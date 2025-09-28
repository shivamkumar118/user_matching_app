<template>
  <BaseLayout>
    <div class="user-profile-container">
      <!-- Header -->
      <div class="user-profile-header">
        <div class="back-button" @click="$router.go(-1)">
          ← Back
        </div>
        <h1 class="user-profile-title">User Profile</h1>
      </div>

      <!-- User Info Card -->
      <div class="user-info-card">
        <div class="user-avatar">
          👨‍💻
        </div>
        <div class="user-details">
          <h2 class="user-name">John Doe</h2>
          <p class="user-location">San Francisco, CA</p>
          <div class="match-score">
            <span class="score-label">Your Match:</span>
            <span class="score-value">87%</span>
          </div>
        </div>
        <div class="user-actions">
          <button class="action-btn primary">Message</button>
          <button class="action-btn secondary">Connect</button>
        </div>
      </div>

      <!-- About Section -->
      <div class="profile-section">
        <h3 class="section-title">About</h3>
        <div class="section-content">
          <p>Passionate software developer with 5+ years of experience in web development. 
          I love creating user-friendly applications and solving complex problems. 
          When I'm not coding, you can find me hiking, reading, or exploring new technologies.</p>
        </div>
      </div>

      <!-- Skills Section -->
      <div class="profile-section">
        <h3 class="section-title">Skills</h3>
        <div class="skills-grid">
          <div class="skill-item">
            <span class="skill-name">JavaScript</span>
            <div class="skill-rating">
              <span class="star">★</span>
              <span class="star">★</span>
              <span class="star">★</span>
              <span class="star">★</span>
              <span class="star">☆</span>
            </div>
          </div>
          <div class="skill-item">
            <span class="skill-name">React</span>
            <div class="skill-rating">
              <span class="star">★</span>
              <span class="star">★</span>
              <span class="star">★</span>
              <span class="star">★</span>
              <span class="star">★</span>
            </div>
          </div>
          <div class="skill-item">
            <span class="skill-name">Node.js</span>
            <div class="skill-rating">
              <span class="star">★</span>
              <span class="star">★</span>
              <span class="star">★</span>
              <span class="star">☆</span>
              <span class="star">☆</span>
            </div>
          </div>
          <div class="skill-item">
            <span class="skill-name">Python</span>
            <div class="skill-rating">
              <span class="star">★</span>
              <span class="star">★</span>
              <span class="star">★</span>
              <span class="star">★</span>
              <span class="star">☆</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Experience Section -->
      <div class="profile-section">
        <h3 class="section-title">Experience</h3>
        <div class="experience-list">
          <div class="experience-item">
            <div class="experience-header">
              <h4>Senior Software Engineer</h4>
              <span class="experience-period">2022 - Present</span>
            </div>
            <p class="company-name">TechCorp Inc.</p>
            <p class="experience-description">
              Leading development of scalable web applications using React and Node.js. 
              Mentoring junior developers and implementing best practices.
            </p>
          </div>
          
          <div class="experience-item">
            <div class="experience-header">
              <h4>Full Stack Developer</h4>
              <span class="experience-period">2020 - 2022</span>
            </div>
            <p class="company-name">StartupXYZ</p>
            <p class="experience-description">
              Built and maintained multiple web applications. 
              Collaborated with cross-functional teams to deliver high-quality products.
            </p>
          </div>
        </div>
      </div>

      <!-- Compatibility Section -->
      <div class="profile-section">
        <h3 class="section-title">Why You Match</h3>
        <div class="compatibility-grid">
          <div class="compatibility-item">
            <div class="compatibility-icon">💬</div>
            <div class="compatibility-content">
              <h4>Communication Style</h4>
              <p>Both prefer direct and clear communication</p>
              <div class="compatibility-bar">
                <div class="bar-fill" style="width: 85%"></div>
              </div>
              <span class="compatibility-percentage">85%</span>
            </div>
          </div>
          
          <div class="compatibility-item">
            <div class="compatibility-icon">🎯</div>
            <div class="compatibility-content">
              <h4>Career Goals</h4>
              <p>Similar aspirations in tech industry</p>
              <div class="compatibility-bar">
                <div class="bar-fill" style="width: 92%"></div>
              </div>
              <span class="compatibility-percentage">92%</span>
            </div>
          </div>
          
          <div class="compatibility-item">
            <div class="compatibility-icon">🌟</div>
            <div class="compatibility-content">
              <h4>Interests</h4>
              <p>Shared passion for innovation</p>
              <div class="compatibility-bar">
                <div class="bar-fill" style="width: 78%"></div>
              </div>
              <span class="compatibility-percentage">78%</span>
            </div>
          </div>
          
          <div class="compatibility-item">
            <div class="compatibility-icon">🤝</div>
            <div class="compatibility-content">
              <h4>Values</h4>
              <p>Aligned on work-life balance</p>
              <div class="compatibility-bar">
                <div class="bar-fill" style="width: 88%"></div>
              </div>
              <span class="compatibility-percentage">88%</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Shared Answers Section -->
      <div class="profile-section">
        <h3 class="section-title">Shared Answers</h3>
        <div class="answers-list">
          <div class="answer-item">
            <h4>How do you prefer to spend your weekends?</h4>
            <p class="answer-text">I love exploring new hiking trails and trying out local coffee shops. Sometimes I'll spend the day coding on personal projects or reading a good book.</p>
            <div class="answer-match">
              <span class="match-indicator">✓</span>
              <span class="match-text">Similar answer</span>
            </div>
          </div>
          
          <div class="answer-item">
            <h4>What motivates you to learn new things?</h4>
            <p class="answer-text">I'm driven by curiosity and the desire to solve real-world problems. I love the feeling of mastering a new skill and being able to help others with it.</p>
            <div class="answer-match">
              <span class="match-indicator">✓</span>
              <span class="match-text">Similar answer</span>
            </div>
          </div>
          
          <div class="answer-item">
            <h4>What's your approach to work-life balance?</h4>
            <p class="answer-text">I believe in setting clear boundaries and prioritizing what matters most. I work hard during the week but make sure to disconnect and recharge on weekends.</p>
            <div class="answer-match">
              <span class="match-indicator">✓</span>
              <span class="match-text">Similar answer</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </BaseLayout>
</template>

<script setup>
import BaseLayout from '@/components/layouts/BaseLayout.vue'
</script>

<style scoped>
.user-profile-container {
  width: 100%;
  max-width: 800px;
  padding: 20px;
  margin: 0 auto;
}

/* Header */
.user-profile-header {
  display: flex;
  align-items: center;
  gap: 20px;
  margin-bottom: 30px;
  animation: fadeInDown 1s ease-out;
}

.back-button {
  color: rgba(255, 255, 255, 0.8);
  font-size: 1rem;
  cursor: pointer;
  padding: 8px 16px;
  border-radius: 20px;
  transition: all 0.3s ease;
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.back-button:hover {
  background: rgba(255, 255, 255, 0.1);
  color: white;
}

.user-profile-title {
  font-size: 2.5rem;
  font-weight: 700;
  color: white;
  background: linear-gradient(135deg, #ff6b6b, #ffd93d, #4ecdc4);
  background-clip: text;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  text-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
}

/* User Info Card */
.user-info-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  border-radius: 20px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  padding: 30px;
  display: flex;
  align-items: center;
  gap: 20px;
  margin-bottom: 30px;
  animation: slideInUp 1s ease-out 0.2s forwards;
  opacity: 0;
}

.user-avatar {
  font-size: 4rem;
  width: 80px;
  height: 80px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 20px;
  flex-shrink: 0;
}

.user-details {
  flex: 1;
}

.user-name {
  color: white;
  font-size: 1.8rem;
  font-weight: 600;
  margin-bottom: 5px;
}

.user-location {
  color: rgba(255, 255, 255, 0.7);
  font-size: 1rem;
  margin-bottom: 10px;
}

.match-score {
  display: flex;
  align-items: center;
  gap: 5px;
}

.score-label {
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.9rem;
}

.score-value {
  color: #4ecdc4;
  font-weight: 700;
  font-size: 1.1rem;
}

.user-actions {
  display: flex;
  gap: 10px;
}

.action-btn {
  padding: 10px 20px;
  border: none;
  border-radius: 20px;
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

/* Profile Sections */
.profile-section {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  border-radius: 20px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  padding: 25px;
  margin-bottom: 20px;
  transition: all 0.3s ease;
  animation: slideInUp 1s ease-out 0.4s forwards;
  opacity: 0;
}

.profile-section:hover {
  transform: translateY(-2px);
  box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
}

.profile-section:nth-child(4) {
  animation-delay: 0.6s;
}

.profile-section:nth-child(5) {
  animation-delay: 0.8s;
}

.profile-section:nth-child(6) {
  animation-delay: 1.0s;
}

.profile-section:nth-child(7) {
  animation-delay: 1.2s;
}

.section-title {
  color: white;
  font-size: 1.4rem;
  font-weight: 600;
  margin-bottom: 20px;
  padding-bottom: 10px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
}

.section-content p {
  color: rgba(255, 255, 255, 0.9);
  line-height: 1.6;
  font-size: 1rem;
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

.experience-header h4 {
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

/* Compatibility Grid */
.compatibility-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 20px;
}

.compatibility-item {
  display: flex;
  align-items: center;
  gap: 15px;
  padding: 20px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 15px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.compatibility-icon {
  font-size: 2rem;
  width: 50px;
  height: 50px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  flex-shrink: 0;
}

.compatibility-content {
  flex: 1;
}

.compatibility-content h4 {
  color: white;
  font-size: 1.1rem;
  font-weight: 600;
  margin-bottom: 5px;
}

.compatibility-content p {
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.9rem;
  margin-bottom: 10px;
  line-height: 1.4;
}

.compatibility-bar {
  width: 100%;
  height: 6px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 3px;
  margin-bottom: 5px;
  overflow: hidden;
}

.bar-fill {
  height: 100%;
  background: linear-gradient(90deg, #4ecdc4, #44a08d);
  border-radius: 3px;
  transition: width 0.3s ease;
}

.compatibility-percentage {
  color: #4ecdc4;
  font-weight: 700;
  font-size: 0.9rem;
}

/* Answers List */
.answers-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.answer-item {
  padding: 20px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 15px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.answer-item h4 {
  color: white;
  font-size: 1.1rem;
  font-weight: 600;
  margin-bottom: 10px;
}

.answer-text {
  color: rgba(255, 255, 255, 0.8);
  line-height: 1.5;
  font-size: 0.9rem;
  margin-bottom: 15px;
}

.answer-match {
  display: flex;
  align-items: center;
  gap: 8px;
}

.match-indicator {
  color: #4ecdc4;
  font-weight: bold;
  font-size: 1.1rem;
}

.match-text {
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.9rem;
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
  .user-profile-container {
    padding: 15px;
  }
  
  .user-profile-title {
    font-size: 2rem;
  }
  
  .user-info-card {
    flex-direction: column;
    text-align: center;
  }
  
  .user-actions {
    justify-content: center;
  }
  
  .skills-grid {
    grid-template-columns: 1fr;
  }
  
  .compatibility-grid {
    grid-template-columns: 1fr;
  }
  
  .experience-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 5px;
  }
}

@media (max-width: 480px) {
  .user-profile-title {
    font-size: 1.8rem;
  }
  
  .user-info-card {
    padding: 20px;
  }
  
  .profile-section {
    padding: 20px;
  }
  
  .compatibility-item {
    flex-direction: column;
    text-align: center;
  }
}
</style> 