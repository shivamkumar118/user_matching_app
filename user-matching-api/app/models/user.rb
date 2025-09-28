class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :experiences, dependent: :destroy
  has_many :skills, dependent: :destroy
  has_many :answers, dependent: :destroy

  # Validations
  validates :first_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :phone, format: { with: /\A\+?[\d\s\-\(\)]+\z/ }, allow_blank: true
  validates :employment_status, inclusion: { in: %w[employed unemployed freelancer student retired] }, allow_blank: true

  # Scopes
  scope :with_complete_profiles, -> { where.not(first_name: nil, last_name: nil, email: nil) }

  # Instance methods
  def full_name
    "#{first_name} #{last_name}"
  end

  def profile_completion_percentage
    required_fields = %w[email first_name last_name]
    optional_fields = %w[phone address bio employment_status about]
    
    completed_required = required_fields.count { |field| send(field).present? }
    completed_optional = optional_fields.count { |field| send(field).present? }
    
    total_fields = required_fields.length + optional_fields.length
    completed_fields = completed_required + completed_optional
    
    ((completed_fields.to_f / total_fields) * 100).round(2)
  end

  def has_answered_questions?
    answers.exists?
  end

  def has_skills?
    skills.exists?
  end

  def has_experience?
    experiences.exists?
  end
end 