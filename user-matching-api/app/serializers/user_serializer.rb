class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :full_name, :phone, :address, 
             :bio, :employment_status, :about, :profile_completion_percentage,
             :has_answered_questions, :has_skills, :has_experience, :created_at, :updated_at

  has_many :experiences, serializer: ExperienceSerializer
  has_many :skills, serializer: SkillSerializer
  has_many :answers, serializer: AnswerSerializer

  def full_name
    object.full_name
  end

  def profile_completion_percentage
    object.profile_completion_percentage
  end

  def has_answered_questions
    object.has_answered_questions?
  end

  def has_skills
    object.has_skills?
  end

  def has_experience
    object.has_experience?
  end
end
