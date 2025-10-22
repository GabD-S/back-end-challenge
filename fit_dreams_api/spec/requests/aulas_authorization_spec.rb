require 'rails_helper'

RSpec.describe 'Aulas authorization and enroll', type: :request do
  def auth_headers_for(user)
    token = JsonWebToken.encode({ user_id: user.id })
    { 'Authorization' => "Bearer #{token}", 'Content-Type' => 'application/json' }
  end

  let!(:category) { create(:category) }
  let!(:aula) { create(:aula, category: category) }
  let!(:aluno) { create(:user, role: :aluno, password: 'Password!23', password_confirmation: 'Password!23') }
  let!(:professor) { create(:user, role: :professor) }

  describe 'GET /api/v1/aulas' do
    it 'returns 401 when unauthenticated' do
      get '/api/v1/aulas'
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns 200 when authenticated' do
      get '/api/v1/aulas', headers: auth_headers_for(aluno)
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body).to be_an(Array)
    end
  end

  describe 'GET /api/v1/aulas/:id' do
    it 'returns 200 when authenticated' do
      get "/api/v1/aulas/#{aula.id}", headers: auth_headers_for(aluno)
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body).to include('id' => aula.id, 'name' => aula.name)
    end
  end

  describe 'POST /api/v1/aulas' do
    let(:valid_params) do
      {
        aula: {
          name: 'Pilates',
          start_time: 2.days.from_now.iso8601,
          duration: 60,
          teacher_name: 'Maria',
          category_id: category.id
        }
      }
    end

    it 'returns 403 for aluno' do
      post '/api/v1/aulas', params: valid_params.to_json, headers: auth_headers_for(aluno)
      expect(response).to have_http_status(:forbidden)
    end

    it 'creates for professor (201)' do
      post '/api/v1/aulas', params: valid_params.to_json, headers: auth_headers_for(professor)
      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body['name']).to eq('Pilates')
    end
  end

  describe 'POST /api/v1/aulas/:id/enroll' do
    it 'enrolls aluno (201)' do
      post "/api/v1/aulas/#{aula.id}/enroll", headers: auth_headers_for(aluno)
      expect(response).to have_http_status(:created)
    end

    it 'forbids staff (403)' do
      post "/api/v1/aulas/#{aula.id}/enroll", headers: auth_headers_for(professor)
      expect(response).to have_http_status(:forbidden)
    end

    it 'returns 422 on duplicate enrollment' do
      post "/api/v1/aulas/#{aula.id}/enroll", headers: auth_headers_for(aluno)
      expect(response).to have_http_status(:created)

      post "/api/v1/aulas/#{aula.id}/enroll", headers: auth_headers_for(aluno)
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
