# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Clear existing data
puts "Clearing existing data..."
User.destroy_all
Question.destroy_all

# Create essential questions (needed for the questions page to work)
puts "Creating essential questions..."
question_data = [
  {
    title: "What's your preferred work environment?",
    category: "professional"
  },
  {
    title: "How do you handle stress and pressure?",
    category: "personal"
  },
  {
    title: "What motivates you the most in your career?",
    category: "professional"
  },
  {
    title: "How do you prefer to spend your weekends?",
    category: "lifestyle"
  },
  {
    title: "What's your communication style in teams?",
    category: "professional"
  },
  {
    title: "How important is work-life balance to you?",
    category: "values"
  },
  {
    title: "What are your long-term career goals?",
    category: "goals"
  },
  {
    title: "How do you approach problem-solving?",
    category: "personal"
  },
  {
    title: "What's your preferred leadership style?",
    category: "professional"
  },
  {
    title: "How do you stay updated with industry trends?",
    category: "professional"
  }
]

questions = []
question_data.each do |q|
  questions << Question.create!(q)
end

# Create test users with complete profiles
puts "Creating test users..."

# User 1: Frontend Developer
user1 = User.create!(
  email: 'sarah.johnson@example.com',
  password: 'password123',
  first_name: 'Sarah',
  last_name: 'Johnson',
  phone: '+1-555-0123',
  address: '123 Tech Street, San Francisco, CA',
  bio: 'Passionate frontend developer with 5 years of experience building modern web applications. Love working with React, Vue.js, and TypeScript.',
  employment_status: 'employed',
  about: 'I enjoy creating beautiful and functional user interfaces. When not coding, I love hiking and photography.'
)

# User 1 Skills
user1.skills.create!([
  { value: 'React', category: 'frameworks', rating: 5 },
  { value: 'Vue.js', category: 'frameworks', rating: 4 },
  { value: 'JavaScript', category: 'programming', rating: 5 },
  { value: 'TypeScript', category: 'programming', rating: 4 },
  { value: 'CSS', category: 'programming', rating: 5 },
  { value: 'HTML', category: 'programming', rating: 5 },
  { value: 'Git', category: 'tools', rating: 4 },
  { value: 'Figma', category: 'tools', rating: 3 }
])

# User 1 Experiences
user1.experiences.create!([
  {
    job_title: 'Senior Frontend Developer',
    company_name: 'TechCorp Inc.',
    start_date: Date.new(2021, 1, 1),
    end_date: nil,
    description: 'Leading frontend development for a SaaS platform with 100k+ users. Mentoring junior developers and implementing best practices.'
  },
  {
    job_title: 'Frontend Developer',
    company_name: 'StartupXYZ',
    start_date: Date.new(2019, 3, 1),
    end_date: Date.new(2020, 12, 31),
    description: 'Built responsive web applications using React and modern JavaScript. Collaborated with design and backend teams.'
  }
])

# User 1 Answers
user1.answers.create!([
  { question: questions[0], answer_text: 'I prefer a collaborative environment with flexible hours and remote work options.' },
  { question: questions[1], answer_text: 'I handle stress by breaking down problems into smaller tasks and taking short breaks to clear my mind.' },
  { question: questions[2], answer_text: 'Creating impactful user experiences and seeing users enjoy the products I build motivates me most.' },
  { question: questions[3], answer_text: 'I love hiking, photography, and spending time with friends and family.' },
  { question: questions[4], answer_text: 'I prefer open communication, regular check-ins, and collaborative decision-making.' }
])

# User 2: Backend Developer
user2 = User.create!(
  email: 'mike.chen@example.com',
  password: 'password123',
  first_name: 'Mike',
  last_name: 'Chen',
  phone: '+1-555-0456',
  address: '456 Data Lane, Seattle, WA',
  bio: 'Backend developer specializing in scalable systems and API design. Expert in Ruby on Rails, Python, and cloud technologies.',
  employment_status: 'employed',
  about: 'I focus on building robust, scalable backend systems. Enjoy solving complex problems and optimizing performance.'
)

# User 2 Skills
user2.skills.create!([
  { value: 'Ruby on Rails', category: 'frameworks', rating: 5 },
  { value: 'Python', category: 'programming', rating: 4 },
  { value: 'PostgreSQL', category: 'databases', rating: 5 },
  { value: 'Redis', category: 'databases', rating: 4 },
  { value: 'AWS', category: 'tools', rating: 4 },
  { value: 'Docker', category: 'tools', rating: 4 },
  { value: 'Git', category: 'tools', rating: 5 },
  { value: 'REST APIs', category: 'programming', rating: 5 }
])

# User 2 Experiences
user2.experiences.create!([
  {
    job_title: 'Senior Backend Developer',
    company_name: 'DataFlow Systems',
    start_date: Date.new(2020, 6, 1),
    end_date: nil,
    description: 'Designing and implementing scalable backend services. Leading architecture decisions and mentoring team members.'
  },
  {
    job_title: 'Software Engineer',
    company_name: 'CloudTech Solutions',
    start_date: Date.new(2018, 1, 1),
    end_date: Date.new(2020, 5, 31),
    description: 'Developed RESTful APIs and microservices. Worked on database optimization and performance improvements.'
  }
])

# User 2 Answers
user2.answers.create!([
  { question: questions[0], answer_text: 'I prefer a quiet, focused environment with clear project goals and deadlines.' },
  { question: questions[1], answer_text: 'I tackle stress by prioritizing tasks and using systematic problem-solving approaches.' },
  { question: questions[2], answer_text: 'Building reliable, scalable systems that serve thousands of users motivates me.' },
  { question: questions[3], answer_text: 'I enjoy reading tech blogs, playing chess, and exploring new programming languages.' },
  { question: questions[4], answer_text: 'I prefer structured communication with clear documentation and regular code reviews.' }
])

# User 3: UX Designer
user3 = User.create!(
  email: 'emma.rodriguez@example.com',
  password: 'password123',
  first_name: 'Emma',
  last_name: 'Rodriguez',
  phone: '+1-555-0789',
  address: '789 Design Ave, Austin, TX',
  bio: 'UX Designer passionate about creating user-centered digital experiences. Specializing in user research and interface design.',
  employment_status: 'freelancer',
  about: 'I believe great design should be both beautiful and functional. Love collaborating with developers to bring ideas to life.'
)

# User 3 Skills
user3.skills.create!([
  { value: 'User Research', category: 'design', rating: 5 },
  { value: 'UI Design', category: 'design', rating: 5 },
  { value: 'Figma', category: 'tools', rating: 5 },
  { value: 'Sketch', category: 'tools', rating: 4 },
  { value: 'Prototyping', category: 'design', rating: 5 },
  { value: 'User Testing', category: 'design', rating: 4 },
  { value: 'Design Systems', category: 'design', rating: 4 },
  { value: 'Adobe Creative Suite', category: 'tools', rating: 4 }
])

# User 3 Experiences
user3.experiences.create!([
  {
    job_title: 'Freelance UX Designer',
    company_name: 'Self-Employed',
    start_date: Date.new(2021, 1, 1),
    end_date: nil,
    description: 'Working with various clients to design user-centered digital products. Conducting user research and creating design systems.'
  },
  {
    job_title: 'UX Designer',
    company_name: 'Creative Agency',
    start_date: Date.new(2019, 2, 1),
    end_date: Date.new(2020, 12, 31),
    description: 'Designed user interfaces for web and mobile applications. Conducted user research and usability testing.'
  }
])

# User 3 Answers
user3.answers.create!([
  { question: questions[0], answer_text: 'I thrive in creative, collaborative environments with flexible schedules and remote work options.' },
  { question: questions[1], answer_text: 'I manage stress through creative activities and taking time to understand the root cause of problems.' },
  { question: questions[2], answer_text: 'Creating meaningful user experiences that solve real problems motivates me most.' },
  { question: questions[3], answer_text: 'I love visiting art galleries, practicing yoga, and exploring new design trends.' },
  { question: questions[4], answer_text: 'I prefer collaborative communication with regular feedback sessions and open discussions.' }
])

# User 4: Product Manager
user4 = User.create!(
  email: 'david.kim@example.com',
  password: 'password123',
  first_name: 'David',
  last_name: 'Kim',
  phone: '+1-555-0321',
  address: '321 Product Blvd, New York, NY',
  bio: 'Product Manager with experience in B2B SaaS and mobile applications. Passionate about data-driven decision making.',
  employment_status: 'employed',
  about: 'I bridge the gap between business goals and user needs. Love working with cross-functional teams to deliver successful products.'
)

# User 4 Skills
user4.skills.create!([
  { value: 'Product Strategy', category: 'business', rating: 5 },
  { value: 'Data Analysis', category: 'business', rating: 4 },
  { value: 'Agile Methodologies', category: 'business', rating: 5 },
  { value: 'User Research', category: 'business', rating: 4 },
  { value: 'SQL', category: 'databases', rating: 3 },
  { value: 'Jira', category: 'tools', rating: 5 },
  { value: 'Figma', category: 'tools', rating: 3 },
  { value: 'Leadership', category: 'soft_skills', rating: 5 }
])

# User 4 Experiences
user4.experiences.create!([
  {
    job_title: 'Senior Product Manager',
    company_name: 'Enterprise Solutions',
    start_date: Date.new(2020, 3, 1),
    end_date: nil,
    description: 'Leading product strategy for enterprise SaaS platform. Managing product roadmap and cross-functional teams.'
  },
  {
    job_title: 'Product Manager',
    company_name: 'MobileTech Inc.',
    start_date: Date.new(2018, 7, 1),
    end_date: Date.new(2020, 2, 28),
    description: 'Managed mobile app development lifecycle. Conducted market research and user interviews.'
  }
])

# User 4 Answers
user4.answers.create!([
  { question: questions[0], answer_text: 'I prefer dynamic environments with clear goals, regular feedback, and collaborative decision-making.' },
  { question: questions[1], answer_text: 'I handle stress by prioritizing tasks, delegating effectively, and maintaining clear communication.' },
  { question: questions[2], answer_text: 'Building products that solve real user problems and drive business growth motivates me.' },
  { question: questions[3], answer_text: 'I enjoy networking events, reading business books, and exploring new restaurants.' },
  { question: questions[4], answer_text: 'I prefer structured communication with regular check-ins and transparent decision-making processes.' }
])

puts "Database seeded successfully!"
puts "Created #{Question.count} essential questions"
puts "Created #{User.count} test users with complete profiles"
puts "Test users created:"
puts "- #{user1.email} (Frontend Developer)"
puts "- #{user2.email} (Backend Developer)"
puts "- #{user3.email} (UX Designer)"
puts "- #{user4.email} (Product Manager)"
puts "All users have password: password123"
