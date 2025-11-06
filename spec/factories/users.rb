FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email(domain: 'example.com') }
    password { 'Password!23' }
    role { :aluno }
  end
end
