class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  # Validations
  validates :answer_text, presence: true, length: { minimum: 5, maximum: 1000 }
  validates :user_id, uniqueness: { scope: :question_id, message: "has already answered this question" }

  # Scopes
  scope :by_question, ->(question) { where(question: question) }
  scope :by_user, ->(user) { where(user: user) }

  # Instance methods
  def question_title
    question.title
  end

  def question_category
    question.category
  end

  def user_name
    user.full_name
  end
end
