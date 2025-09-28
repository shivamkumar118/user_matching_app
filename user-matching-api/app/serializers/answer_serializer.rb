class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :answer_text, :question_id, :question_title, :question_category, :created_at, :updated_at

  belongs_to :question, serializer: QuestionSerializer
  belongs_to :user, serializer: UserSerializer

  def question_title
    object.question_title
  end

  def question_category
    object.question_category
  end
end
