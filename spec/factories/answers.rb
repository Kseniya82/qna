FactoryBot.define do
  sequence :body do |n|
    "MyText#{n}"
  end
  factory :answer do
    body
    question 
    user { nil }

    trait :invalid do
      body { nil }
    end
  end
end
