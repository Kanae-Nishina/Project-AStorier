FactoryBot.define do
  factory :profile do
    association :user
    text { "profile text" }
  end
end
