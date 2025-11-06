require 'rails_helper'

RSpec.describe Aula, type: :model do
  let(:category) { create(:category) }

  it 'requires presence of key fields and positive duration' do
    aula = Aula.new
    expect(aula.valid?).to be_falsey
    expect(aula.errors[:name]).to be_present
    expect(aula.errors[:start_time]).to be_present
    expect(aula.errors[:duration]).to be_present
    expect(aula.errors[:teacher_name]).to be_present
    expect(aula.errors[:category]).to be_present

    aula.name = 'Yoga'
    aula.start_time = Time.now
    aula.duration = -5
    aula.teacher_name = 'Sensei'
    aula.category = category
    expect(aula.valid?).to be_falsey
    expect(aula.errors[:duration]).to be_present

    aula.duration = 60
    expect(aula.valid?).to be_truthy
  end

  it 'relates alunos through enrollments and destroys enrollments on aula destroy' do
  u = create(:user)
  a = create(:aula, category: category)
  e = create(:enrollment, user: u, aula: a)

    expect(a.alunos).to include(u)
    expect { a.destroy }.to change { Enrollment.where(id: e.id).count }.from(1).to(0)
  end
end
