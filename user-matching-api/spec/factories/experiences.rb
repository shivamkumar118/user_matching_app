FactoryBot.define do
  factory :experience do
    association :user
    job_title { Faker::Job.title }
    company_name { Faker::Company.name }
    start_date { Faker::Date.between(from: 5.years.ago, to: 1.year.ago) }
    end_date { nil }
    description { Faker::Lorem.paragraph(sentence_count: 3) }

    trait :current do
      end_date { nil }
    end

    trait :past do
      end_date { Faker::Date.between(from: start_date, to: Date.current) }
    end

    trait :software_engineer do
      job_title { 'Software Engineer' }
      company_name { Faker::Company.tech_company }
      description { 'Developed web applications using modern technologies and frameworks.' }
    end

    trait :designer do
      job_title { 'UX/UI Designer' }
      company_name { Faker::Company.tech_company }
      description { 'Created user-centered design solutions for digital products.' }
    end

    trait :product_manager do
      job_title { 'Product Manager' }
      company_name { Faker::Company.tech_company }
      description { 'Managed product roadmap and coordinated cross-functional teams.' }
    end

    trait :data_scientist do
      job_title { 'Data Scientist' }
      company_name { Faker::Company.tech_company }
      description { 'Built machine learning models for predictive analytics.' }
    end
  end
end
