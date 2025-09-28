class Api::V1::ExperiencesController < ApplicationController
  before_action :authenticate_user_from_token!
  before_action :authenticate_user!
  before_action :set_experience, only: [:update, :destroy]

  def index
    experiences = current_user.experiences.ordered_by_start_date
    render_success(experiences.map { |experience| ExperienceSerializer.new(experience).as_json }, 'Experiences retrieved successfully')
  end

  def create
    experience = current_user.experiences.build(experience_params)
    
    if experience.save
      render_success(ExperienceSerializer.new(experience).as_json, 'Experience created successfully', :created)
    else
      render_error('Experience creation failed', experience.errors.full_messages)
    end
  end

  def update
    if @experience.update(experience_params)
      render_success(ExperienceSerializer.new(@experience).as_json, 'Experience updated successfully')
    else
      render_error('Experience update failed', @experience.errors.full_messages)
    end
  end

  def destroy
    @experience.destroy
    render_success(nil, 'Experience deleted successfully')
  end

  private

  def set_experience
    @experience = current_user.experiences.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_error('Experience not found', nil, :not_found)
  end

  def experience_params
    params.require(:experience).permit(:job_title, :company_name, :start_date, :end_date, :description)
  end
end
