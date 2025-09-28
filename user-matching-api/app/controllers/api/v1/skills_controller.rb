class Api::V1::SkillsController < ApplicationController
  before_action :authenticate_user_from_token!
  before_action :authenticate_user!
  before_action :set_skill, only: [:update, :destroy]

  def index
    skills = current_user.skills.ordered_by_rating
    render_success(skills.map { |skill| SkillSerializer.new(skill).as_json }, 'Skills retrieved successfully')
  end

  def create
    skill = current_user.skills.build(skill_params)
    
    if skill.save
      render_success(SkillSerializer.new(skill).as_json, 'Skill created successfully', :created)
    else
      render_error('Skill creation failed', skill.errors.full_messages)
    end
  end

  def update
    if @skill.update(skill_params)
      render_success(SkillSerializer.new(@skill).as_json, 'Skill updated successfully')
    else
      render_error('Skill update failed', @skill.errors.full_messages)
    end
  end

  def destroy
    @skill.destroy
    render_success(nil, 'Skill deleted successfully')
  end

  private

  def set_skill
    @skill = current_user.skills.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_error('Skill not found', nil, :not_found)
  end

  def skill_params
    params.require(:skill).permit(:value, :category, :rating)
  end
end
