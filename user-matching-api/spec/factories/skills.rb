FactoryBot.define do
  factory :skill do
    association :user
    value { ['Ruby', 'Python', 'JavaScript', 'Java', 'C++', 'Go', 'Rust', 'PHP', 'Swift', 'Kotlin'].sample }
    category { Skill::CATEGORIES.sample }
    rating { rand(1..5) }

    trait :programming do
      category { 'programming' }
      value { ['Ruby', 'Python', 'JavaScript', 'Java', 'C++', 'Go', 'Rust', 'PHP', 'Swift', 'Kotlin'].sample }
    end

    trait :frameworks do
      category { 'frameworks' }
      value { ['React', 'Vue.js', 'Angular', 'Ruby on Rails', 'Django'].sample }
    end

    trait :databases do
      category { 'databases' }
      value { ['PostgreSQL', 'MySQL', 'MongoDB', 'Redis'].sample }
    end

    trait :design do
      category { 'design' }
      value { ['Figma', 'Sketch', 'Adobe XD', 'Photoshop'].sample }
    end

    trait :business do
      category { 'business' }
      value { ['Agile', 'Scrum', 'Product Strategy', 'Data Analysis'].sample }
    end

    trait :high_rated do
      rating { rand(4..5) }
    end

    trait :low_rated do
      rating { rand(1..2) }
    end
  end
end
