class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :category, :answer_count, :created_at, :updated_at

  has_many :answers, serializer: AnswerSerializer

  def answer_count
    object.answer_count
  end
end
