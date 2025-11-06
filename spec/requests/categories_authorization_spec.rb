require 'rails_helper'

RSpec.describe 'Categories authorization', type: :request do
  let(:headers_for) do
    lambda do |user|
      token = JsonWebToken.encode({ user_id: user.id })
      { 'Authorization' => "Bearer #{token}", 'Content-Type' => 'application/json' }
    end
  end

  let(:valid_params) { { name: 'Nova Categoria' } }

  context 'as aluno' do
    let(:aluno) { create(:user, role: :aluno, password: 'Password!23', password_confirmation: 'Password!23') }

    it 'cannot create category (expects 403)' do
      post '/api/v1/categories', params: valid_params.to_json, headers: headers_for.call(aluno)
      expect(response.status).to eq(403)
    end
  end

  context 'as professor' do
    let(:professor) { create(:user, role: :professor, password: 'Password!23', password_confirmation: 'Password!23') }

    it 'can create category (expects 201)' do
      post '/api/v1/categories', params: valid_params.to_json, headers: headers_for.call(professor)
      expect(response.status).to eq(201)
    end
  end
end
