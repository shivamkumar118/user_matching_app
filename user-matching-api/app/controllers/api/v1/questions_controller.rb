class Api::V1::QuestionsController < ApplicationController
  before_action :authenticate_user_from_token!
  before_action :authenticate_user!

  def index
    questions = Question.ordered_by_category
    render_success(questions.map { |question| QuestionSerializer.new(question).as_json }, 'Questions retrieved successfully')
  end

  def show
    question = Question.find(params[:id])
    render_success(QuestionSerializer.new(question).as_json, 'Question retrieved successfully')
  rescue ActiveRecord::RecordNotFound
    render_error('Question not found', nil, :not_found)
  end
end
