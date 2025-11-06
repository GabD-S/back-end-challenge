require 'rails_helper'

RSpec.describe 'Signup', type: :request do
  describe 'POST /api/v1/signup' do
    let(:valid_params) do
      {
        user: {
          name: 'João da Silva',
          email: 'joao.silva@example.com',
          password: 'Password!23',
          password_confirmation: 'Password!23'
        }
      }
    end

    it 'creates a new user and returns JWT (201)' do
      post '/api/v1/signup', params: valid_params.to_json, headers: { 'Content-Type' => 'application/json' }

      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body['data']['token']).to be_present
      expect(body['data']['exp']).to be_a(Integer)
      expect(body['data']['user']).to include('email' => 'joao.silva@example.com')
      expect(User.find_by(email: 'joao.silva@example.com')).to be_present
    end

    it 'returns 422 on validation error' do
      bad_params = valid_params.deep_merge(user: { password_confirmation: 'mismatch' })
      post '/api/v1/signup', params: bad_params.to_json, headers: { 'Content-Type' => 'application/json' }

      expect(response).to have_http_status(:unprocessable_entity)
      body = JSON.parse(response.body)
      expect(body['errors']).to be_an(Array)
      expect(body['errors']).not_to be_empty
    end
  end
end
