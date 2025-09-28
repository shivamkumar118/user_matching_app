FactoryBot.define do
  factory :answer do
    association :user
    association :question
    answer_text { Faker::Lorem.paragraph(sentence_count: 2) }

    trait :short_answer do
      answer_text { Faker::Lorem.sentence(word_count: 5) }
    end

    trait :long_answer do
      answer_text { Faker::Lorem.paragraph(sentence_count: 5) }
    end
  end
end
