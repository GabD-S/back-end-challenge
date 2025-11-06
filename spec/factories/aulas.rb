FactoryBot.define do
  factory :aula do
    name { Faker::Educator.course_name }
    start_time { Faker::Time.forward(days: 5, period: :morning) }
  duration { [ 30, 45, 60, 90 ].sample }
    teacher_name { Faker::Name.name }
    association :category
  end
end
