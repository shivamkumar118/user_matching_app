class SkillSerializer < ActiveModel::Serializer
  attributes :id, :value, :category, :rating, :proficiency_level, :created_at, :updated_at

  def proficiency_level
    object.proficiency_level
  end
end
