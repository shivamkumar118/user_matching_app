FactoryBot.define do
  factory :question do
    title { Faker::Lorem.sentence(word_count: 5) + "?" }
    category { Question::CATEGORIES.sample }

    trait :professional do
      category { 'professional' }
    end

    trait :personal do
      category { 'personal' }
    end

    trait :lifestyle do
      category { 'lifestyle' }
    end

    trait :values do
      category { 'values' }
    end

    trait :goals do
      category { 'goals' }
    end

    trait :preferences do
      category { 'preferences' }
    end
  end
end
