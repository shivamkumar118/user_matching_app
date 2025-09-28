require 'rails_helper'

RSpec.describe 'Api::V1::Skills', type: :request do
  let(:user) { create(:user, :with_complete_profile) }
  let!(:existing_skill) { create(:skill, :programming, user: user, value: 'Ruby', rating: 5) }
  let!(:another_skill) { create(:skill, :frameworks, user: user, value: 'Rails', rating: 4) }

  describe 'GET /api/v1/skills' do
    context 'with authenticated user' do
      it 'returns user skills ordered by rating' do
        get '/api/v1/skills', headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('Skills retrieved successfully')
        expect(json_response['data']).to be_an(Array)
        expect(json_response['data'].length).to eq(2)
        
        # Check that skills are ordered by rating (highest first)
        skills = json_response['data']
        expect(skills.first['rating']).to be >= skills.last['rating']
      end

      it 'includes skill attributes' do
        get '/api/v1/skills', headers: auth_headers(user)

        json_response = JSON.parse(response.body)
        skill = json_response['data'].first
        
        expect(skill).to include('id', 'value', 'category', 'rating', 'proficiency_level', 'created_at', 'updated_at')
        expect(skill['value']).to be_present
        expect(skill['category']).to be_present
        expect(skill['rating']).to be_between(1, 5)
        expect(skill['proficiency_level']).to be_present
      end
    end

    context 'without authentication' do
      it 'returns unauthorized error' do
        get '/api/v1/skills'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /api/v1/skills' do
    let(:valid_params) do
      {
        skill: {
          value: 'JavaScript',
          category: 'programming',
          rating: 4
        }
      }
    end

    context 'with authenticated user' do
      it 'creates a new skill' do
        expect {
          post '/api/v1/skills', params: valid_params, headers: auth_headers(user)
        }.to change(Skill, :count).by(1)

        expect(response).to have_http_status(:created)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('Skill created successfully')
        expect(json_response['data']['value']).to eq('JavaScript')
        expect(json_response['data']['category']).to eq('programming')
        expect(json_response['data']['rating']).to eq(4)
        expect(json_response['data']['proficiency_level']).to eq('Advanced')
      end

      it 'returns validation errors for invalid params' do
        invalid_params = {
          skill: {
            value: 'A', # Too short
            category: 'invalid_category',
            rating: 6 # Invalid rating
          }
        }

        post '/api/v1/skills', params: invalid_params, headers: auth_headers(user)

        expect(response).to have_http_status(:unprocessable_entity)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to eq('Skill creation failed')
        expect(json_response['errors']).to be_present
      end

      it 'allows creating skills with different categories' do
        design_params = {
          skill: {
            value: 'Figma',
            category: 'design',
            rating: 3
          }
        }

        post '/api/v1/skills', params: design_params, headers: auth_headers(user)

        expect(response).to have_http_status(:created)
        
        json_response = JSON.parse(response.body)
        expect(json_response['data']['category']).to eq('design')
        expect(json_response['data']['proficiency_level']).to eq('Intermediate')
      end
    end

    context 'without authentication' do
      it 'returns unauthorized error' do
        post '/api/v1/skills', params: valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT /api/v1/skills/:id' do
    let(:valid_params) do
      {
        skill: {
          value: 'Ruby on Rails',
          rating: 5
        }
      }
    end

    context 'with authenticated user' do
      it 'updates the skill' do
        put "/api/v1/skills/#{existing_skill.id}", params: valid_params, headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('Skill updated successfully')
        expect(json_response['data']['value']).to eq('Ruby on Rails')
        expect(json_response['data']['rating']).to eq(5)
        expect(json_response['data']['proficiency_level']).to eq('Expert')
      end

      it 'returns validation errors for invalid params' do
        invalid_params = {
          skill: {
            value: '', # Empty value
            rating: 0 # Invalid rating
          }
        }

        put "/api/v1/skills/#{existing_skill.id}", params: invalid_params, headers: auth_headers(user)

        expect(response).to have_http_status(:unprocessable_entity)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to eq('Skill update failed')
        expect(json_response['errors']).to be_present
      end

      it 'returns not found for non-existent skill' do
        put '/api/v1/skills/99999', params: valid_params, headers: auth_headers(user)
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'without authentication' do
      it 'returns unauthorized error' do
        put "/api/v1/skills/#{existing_skill.id}", params: valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/v1/skills/:id' do
    context 'with authenticated user' do
      it 'deletes the skill' do
        expect {
          delete "/api/v1/skills/#{existing_skill.id}", headers: auth_headers(user)
        }.to change(Skill, :count).by(-1)

        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('Skill deleted successfully')
      end

      it 'returns not found for non-existent skill' do
        delete '/api/v1/skills/99999', headers: auth_headers(user)
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'without authentication' do
      it 'returns unauthorized error' do
        delete "/api/v1/skills/#{existing_skill.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end 