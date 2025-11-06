require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it 'relates aulas through enrollments and destroys enrollments on user destroy' do
      user = create(:user)
      aula = create(:aula)
      enrollment = create(:enrollment, user: user, aula: aula)

      expect(user.aulas).to include(aula)
      expect { user.destroy }.to change { Enrollment.where(id: enrollment.id).count }.from(1).to(0)
    end
  end

  describe 'enum role' do
    it 'has expected roles and default' do
      user = create(:user)
      expect(user.role).to eq('aluno')
      expect(User.roles).to include('aluno' => 0, 'professor' => 1, 'admin' => 2)
    end
  end

  describe 'validations' do
    it 'requires name and email' do
      user = described_class.new(password: '123456')
      expect(user.valid?).to be_falsey
      expect(user.errors[:name]).to be_present
      expect(user.errors[:email]).to be_present
    end

    it 'enforces uniqueness of email' do
      create(:user, email: 'dup@example.com')
      dup = build(:user, email: 'dup@example.com')
      expect(dup.valid?).to be_falsey
      expect(dup.errors[:email]).to be_present
    end

    it 'normalizes email to lowercase and trims whitespace' do
      user = build(:user, email: '  MIXED.Case+test@Example.COM  ')
      expect(user.valid?).to be_truthy
      expect(user.email).to eq('mixed.case+test@example.com')
    end

    it 'rejects invalid email format' do
      user = build(:user, email: 'invalid-email')
      expect(user.valid?).to be_falsey
      expect(user.errors[:email]).to be_present
    end

    it 'enforces case-insensitive uniqueness of email' do
      create(:user, email: 'case@test.com')
      dup = build(:user, email: 'CASE@test.COM')
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
