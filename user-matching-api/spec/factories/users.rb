FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { 'password123' }
    password_confirmation { 'password123' }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone { '+1-555-123-4567' }
    address { Faker::Address.full_address }
    bio { Faker::Lorem.paragraph(sentence_count: 3) }
    employment_status { %w[employed unemployed freelancer student retired].sample }
    about { Faker::Lorem.paragraph(sentence_count: 2) }

    trait :with_complete_profile do
      phone { '+1-555-123-4567' }
      address { Faker::Address.full_address }
      bio { Faker::Lorem.paragraph(sentence_count: 3) }
      employment_status { 'employed' }
      about { Faker::Lorem.paragraph(sentence_count: 2) }
    end

    trait :employed do
      employment_status { 'employed' }
    end

    trait :freelancer do
      employment_status { 'freelancer' }
    end

    trait :student do
      employment_status { 'student' }
    end
  end
end
