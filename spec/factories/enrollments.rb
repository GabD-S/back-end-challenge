FactoryBot.define do
  factory :enrollment do
    association :user
    association :aula
  end
end
