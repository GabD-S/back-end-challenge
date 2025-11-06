# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "faker"

puts 'Seeding database with sample data...'

roles = %i[aluno professor admin]

5.times do
  User.find_or_create_by!(email: Faker::Internet.unique.email(domain: "example.com")) do |u|
    u.name = Faker::Name.name
    u.password = "Password!23"
    u.role = roles.sample
  end
end

%w[Cardio Força Yoga Dança].each do |cat_name|
  Category.find_or_create_by!(name: cat_name)
end

Category.find_each do |category|
  2.times do
    Aula.find_or_create_by!(
      name: Faker::Educator.course_name,
      start_time: Faker::Time.forward(days: 7, period: :afternoon),
      duration: [ 30, 45, 60, 90 ].sample,
      teacher_name: Faker::Name.name,
      category: category
    )
  end
end

puts 'Seeding done.'
