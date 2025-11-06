require 'rails_helper'

RSpec.describe Category, type: :model do
  it 'requires name' do
    c = Category.new
    expect(c.valid?).to be_falsey
    expect(c.errors[:name]).to be_present
  end

  it 'is valid with a name' do
    c = Category.new(name: 'Treino')
    expect(c.valid?).to be_truthy
  end
end
