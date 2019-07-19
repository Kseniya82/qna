FactoryBot.define do
  factory :comment do
    body { "Comment" }
  end
  trait :invalid do
    body { nil }
  end
end
