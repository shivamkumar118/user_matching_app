class Api::V1::AnswersController < ApplicationController
  before_action :authenticate_user_from_token!
  before_action :authenticate_user!
  before_action :set_answer, only: [:update, :destroy]

  def index
    answers = current_user.answers.includes(:question)
    render_success(answers.map { |answer| AnswerSerializer.new(answer).as_json }, 'Answers retrieved successfully')
  end

  def create
    answer = current_user.answers.build(answer_params)
    
    if answer.save
      render_success(AnswerSerializer.new(answer).as_json, 'Answer created successfully', :created)
    else
      render_error('Answer creation failed', answer.errors.full_messages)
    end
  end

  def update
    if @answer.update(answer_params)
      render_success(AnswerSerializer.new(@answer).as_json, 'Answer updated successfully')
    else
      render_error('Answer update failed', @answer.errors.full_messages)
    end
  end

  def destroy
    @answer.destroy
    render_success(nil, 'Answer deleted successfully')
  end

  private

  def set_answer
    @answer = current_user.answers.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_error('Answer not found', nil, :not_found)
  end

  def answer_params
    params.require(:answer).permit(:question_id, :answer_text)
  end
end
