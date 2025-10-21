require 'rails_helper'

RSpec.describe Enrollment, type: :model do
  it 'prevents duplicate enrollment for the same user and aula' do
    user = User.create!(name: 'U', email: 'u2@ex.com', password: '123456')
    category = Category.create!(name: 'Cat')
    aula = Aula.create!(name: 'A', start_time: Time.now, duration: 30, teacher_name: 'T', category: category)
    Enrollment.create!(user: user, aula: aula)

    dup = Enrollment.new(user: user, aula: aula)
    expect(dup.valid?).to be_falsey
    expect(dup.errors[:user_id]).to be_present
  end
end
