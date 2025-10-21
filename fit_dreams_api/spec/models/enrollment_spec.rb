require 'rails_helper'

RSpec.describe Enrollment, type: :model do
  it 'prevents duplicate enrollment for the same user and aula' do
  user = create(:user)
  aula = create(:aula)
  create(:enrollment, user: user, aula: aula)

  dup = build(:enrollment, user: user, aula: aula)
    expect(dup.valid?).to be_falsey
    expect(dup.errors[:user_id]).to be_present
  end
end
