require 'rails_helper'

RSpec.describe 'Aulas update/destroy', type: :request do
  def auth_headers_for(user)
    token = JsonWebToken.encode({ user_id: user.id })
    { 'Authorization' => "Bearer #{token}", 'Content-Type' => 'application/json' }
  end

  let!(:category) { create(:category) }
  let!(:aula) { create(:aula, category: category) }
  let!(:aluno) { create(:user, role: :aluno) }
  let!(:professor) { create(:user, role: :professor) }

  describe 'PATCH /api/v1/aulas/:id' do
    it 'returns 403 for aluno' do
      patch "/api/v1/aulas/#{aula.id}", params: { aula: { name: 'Novo nome' } }.to_json, headers: auth_headers_for(aluno)
      expect(response).to have_http_status(:forbidden)
    end

    it 'updates for staff (200)' do
      patch "/api/v1/aulas/#{aula.id}", params: { aula: { name: 'Novo nome' } }.to_json, headers: auth_headers_for(professor)
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body['data']['name']).to eq('Novo nome')
    end

    it 'returns 422 on invalid data' do
      patch "/api/v1/aulas/#{aula.id}", params: { aula: { duration: 0 } }.to_json, headers: auth_headers_for(professor)
      expect(response).to have_http_status(:unprocessable_entity)
      body = JSON.parse(response.body)
      expect(body['errors']).to be_an(Array)
    end
  end

  describe 'DELETE /api/v1/aulas/:id' do
    it 'returns 403 for aluno' do
      delete "/api/v1/aulas/#{aula.id}", headers: auth_headers_for(aluno)
      expect(response).to have_http_status(:forbidden)
    end

    it 'deletes for staff (204)' do
      delete "/api/v1/aulas/#{aula.id}", headers: auth_headers_for(professor)
      expect(response).to have_http_status(:no_content)
      expect(Aula.where(id: aula.id)).to be_empty
    end
  end
end
