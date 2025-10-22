require 'rails_helper'

RSpec.describe 'Categories index', type: :request do
  let(:password) { 'Password!23' }
  let!(:categories) { create_list(:category, 3) }

  def auth_headers_for(user)
    token = JsonWebToken.encode({ user_id: user.id })
    { 'Authorization' => "Bearer #{token}" }
  end

  context 'when unauthenticated' do
    it 'returns 401' do
      get '/api/v1/categories'
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'when authenticated' do
    let!(:user) { create(:user, role: :aluno, password: password, password_confirmation: password) }

    it 'returns 200 and the list of categories' do
      get '/api/v1/categories', headers: auth_headers_for(user)
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body).to be_an(Array)
      expect(body.size).to eq(Category.count)
      # Ensure the payload contains expected fields
      expect(body.first).to include('id', 'name')
    end
  end
end
