require 'rails_helper'

RSpec.describe 'Me endpoint', type: :request do
  def auth_headers_for(user)
    token = JsonWebToken.encode({ user_id: user.id })
    { 'Authorization' => "Bearer #{token}" }
  end

  describe 'GET /api/v1/me' do
    it 'returns 401 when unauthenticated' do
      get '/api/v1/me'
      expect(response).to have_http_status(:unauthorized)
      body = JSON.parse(response.body)
      expect(body['errors']).to be_an(Array)
    end

    it 'returns 200 with current user when authenticated' do
      user = create(:user)
      get '/api/v1/me', headers: auth_headers_for(user)
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body['data']).to include('id' => user.id, 'email' => user.email)
    end
  end
end
