class Skill < ApplicationRecord
  belongs_to :user

  # Validations
  validates :value, presence: true, length: { minimum: 2, maximum: 100 }
  validates :category, presence: true, length: { minimum: 2, maximum: 50 }
  validates :rating, presence: true, inclusion: { in: 1..5 }

  # Scopes
  scope :by_category, ->(category) { where(category: category) }
  scope :high_rated, -> { where(rating: 4..5) }
  scope :ordered_by_rating, -> { order(rating: :desc) }

  # Constants
  CATEGORIES = %w[programming design marketing business soft_skills languages tools frameworks databases].freeze

  # Validations
  validates :category, inclusion: { in: CATEGORIES }

  # Instance methods
  def proficiency_level
    case rating
    when 1 then "Beginner"
    when 2 then "Elementary"
    when 3 then "Intermediate"
    when 4 then "Advanced"
    when 5 then "Expert"
    end
  end
end
