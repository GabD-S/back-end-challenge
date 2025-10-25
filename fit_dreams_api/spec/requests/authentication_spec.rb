require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  describe 'POST /api/v1/login' do
    let(:password) { 'password123' }
    let!(:user) { create(:user, password: password, password_confirmation: password) }

    it 'returns a JWT token on valid credentials' do
      post '/api/v1/login', params: { email: user.email, password: password }

  expect(response).to have_http_status(:ok)
  body = JSON.parse(response.body)
  expect(body['data']['token']).to be_present
  expect(body['data']['exp']).to be_a(Integer)
  expect(body['data']['user']).to include('id' => user.id, 'email' => user.email)
    end

    it 'is case-insensitive on email' do
      post '/api/v1/login', params: { email: user.email.upcase, password: password }

  expect(response).to have_http_status(:ok)
  body = JSON.parse(response.body)
  expect(body['data']['token']).to be_present
    end

    it 'returns 401 on invalid password' do
      post '/api/v1/login', params: { email: user.email, password: 'wrong' }

  expect(response).to have_http_status(:unauthorized)
  body = JSON.parse(response.body)
  expect(body['errors']).to be_an(Array)
  expect(body['errors']).not_to be_empty
    end

    it 'returns 401 on unknown email' do
      post '/api/v1/login', params: { email: 'unknown@example.com', password: 'irrelevant' }

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
