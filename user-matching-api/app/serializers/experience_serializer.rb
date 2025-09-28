class ExperienceSerializer < ActiveModel::Serializer
  attributes :id, :job_title, :company_name, :start_date, :end_date, :description,
             :duration_in_months, :duration_text, :is_current, :created_at, :updated_at

  def duration_in_months
    object.duration_in_months
  end

  def duration_text
    object.duration_text
  end

  def is_current
    object.is_current?
  end
end
