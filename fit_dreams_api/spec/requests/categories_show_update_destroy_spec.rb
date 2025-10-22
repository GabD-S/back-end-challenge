require 'rails_helper'

RSpec.describe 'Categories show/update/destroy', type: :request do
  def auth_headers_for(user)
    token = JsonWebToken.encode({ user_id: user.id })
    { 'Authorization' => "Bearer #{token}", 'Content-Type' => 'application/json' }
  end

  let!(:category) { create(:category) }
  let!(:aluno) { create(:user, role: :aluno) }
  let!(:professor) { create(:user, role: :professor) }

  describe 'GET /api/v1/categories/:id' do
    it 'returns 401 when unauthenticated' do
      get "/api/v1/categories/#{category.id}"
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns 200 when authenticated' do
      get "/api/v1/categories/#{category.id}", headers: auth_headers_for(aluno)
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body).to include('id' => category.id, 'name' => category.name)
    end
  end

  describe 'PATCH /api/v1/categories/:id' do
    it 'returns 403 for aluno' do
      patch "/api/v1/categories/#{category.id}", params: { category: { name: 'Novo' } }.to_json, headers: auth_headers_for(aluno)
      expect(response).to have_http_status(:forbidden)
    end

    it 'updates for professor (200)' do
      patch "/api/v1/categories/#{category.id}", params: { category: { name: 'Novo' } }.to_json, headers: auth_headers_for(professor)
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body['name']).to eq('Novo')
    end
  end

  describe 'DELETE /api/v1/categories/:id' do
    it 'returns 403 for aluno' do
      delete "/api/v1/categories/#{category.id}", headers: auth_headers_for(aluno)
      expect(response).to have_http_status(:forbidden)
    end

    it 'deletes for professor (204)' do
      delete "/api/v1/categories/#{category.id}", headers: auth_headers_for(professor)
      expect(response).to have_http_status(:no_content)
      expect(Category.where(id: category.id)).to be_empty
    end
  end
end
