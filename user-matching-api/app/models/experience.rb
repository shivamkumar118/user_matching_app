class Experience < ApplicationRecord
  belongs_to :user

  # Validations
  validates :job_title, presence: true, length: { minimum: 2, maximum: 100 }
  validates :company_name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :start_date, presence: true
  validates :end_date, comparison: { greater_than: :start_date }, allow_blank: true
  validates :description, length: { maximum: 1000 }

  # Scopes
  scope :current, -> { where(end_date: nil) }
  scope :past, -> { where.not(end_date: nil) }
  scope :ordered_by_start_date, -> { order(start_date: :desc) }

  # Instance methods
  def duration_in_months
    end_date = self.end_date || Date.current
    ((end_date.year * 12 + end_date.month) - (start_date.year * 12 + start_date.month)).abs
  end

  def duration_text
    months = duration_in_months
    if months < 12
      "#{months} month#{months == 1 ? '' : 's'}"
    else
      years = months / 12
      remaining_months = months % 12
      if remaining_months == 0
        "#{years} year#{years == 1 ? '' : 's'}"
      else
        "#{years} year#{years == 1 ? '' : 's'} #{remaining_months} month#{remaining_months == 1 ? '' : 's'}"
      end
    end
  end

  def is_current?
    end_date.nil?
  end
end
