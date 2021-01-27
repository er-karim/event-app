FactoryBot.define do
  factory :group_event do
    name { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph }
    location { Faker::Address.full_address }
    duration { Faker::Number.number(digits: 2) }
    start_at { Faker::Date.in_date_period }
    is_draft { true }
    is_deleted { false }

    trait :published do
      is_draft { false }
    end

    trait :deleted do
      is_deleted { true }
    end
  end
end
