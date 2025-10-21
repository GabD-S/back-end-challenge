require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it 'relates aulas through enrollments and destroys enrollments on user destroy' do
      user = User.create!(name: 'U', email: 'u@example.com', password: '123456', role: :aluno)
      category = Category.create!(name: 'Cat')
      aula = Aula.create!(name: 'A', start_time: Time.now, duration: 60, teacher_name: 'T', category: category)
      enrollment = Enrollment.create!(user: user, aula: aula)

      expect(user.aulas).to include(aula)
      expect { user.destroy }.to change { Enrollment.where(id: enrollment.id).count }.from(1).to(0)
    end
  end

  describe 'enum role' do
    it 'has expected roles and default' do
      user = User.create!(name: 'U', email: 'role@example.com', password: '123456')
      expect(user.role).to eq('aluno')
      expect(User.roles).to include('aluno' => 0, 'professor' => 1, 'admin' => 2)
    end
  end

  describe 'validations' do
    it 'requires name and email' do
      user = User.new(password: '123456')
      expect(user.valid?).to be_falsey
      expect(user.errors[:name]).to be_present
      expect(user.errors[:email]).to be_present
    end

    it 'enforces uniqueness of email' do
      User.create!(name: 'A', email: 'dup@example.com', password: '123456')
      dup = User.new(name: 'B', email: 'dup@example.com', password: 'abcdef')
      expect(dup.valid?).to be_falsey
      expect(dup.errors[:email]).to be_present
    end
  end

  describe 'secure password' do
    it 'hashes password and authenticates' do
      user = User.create!(name: 'Teste', email: 't@e.com', password: '123456', role: :aluno)
      expect(user.authenticate('123456')).to be_truthy
      expect(user.authenticate('wrong')).to be_falsey
    end
  end
end
