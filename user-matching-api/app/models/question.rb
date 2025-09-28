class Question < ApplicationRecord
  has_many :answers, dependent: :destroy

  # Validations
  validates :title, presence: true, uniqueness: true, length: { minimum: 10, maximum: 500 }
  validates :category, presence: true, length: { minimum: 2, maximum: 50 }

  # Scopes
  scope :by_category, ->(category) { where(category: category) }
  scope :ordered_by_category, -> { order(:category, :title) }

  # Constants
  CATEGORIES = %w[personal professional lifestyle values goals preferences].freeze

  # Validations
  validates :category, inclusion: { in: CATEGORIES }

  # Instance methods
  def answered_by_user?(user)
    answers.exists?(user: user)
  end

  def user_answer(user)
    answers.find_by(user: user)
  end

  def answer_count
    answers.count
  end
end
