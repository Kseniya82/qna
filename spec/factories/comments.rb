FactoryBot.define do
  factory :comment do
    body { "Comment" }
    user
  end
  trait :invalid do
    body { nil }
  end
end
