require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  let!(:user) { create(:user, :with_complete_profile) }
  let!(:other_user) { create(:user, :with_complete_profile) }

  describe 'GET /api/v1/users' do
    context 'with authenticated user' do
      it 'returns all users' do
        get '/api/v1/users', headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('Users retrieved successfully')
        expect(json_response['data']).to be_an(Array)
        expect(json_response['data'].length).to eq(2) # user and other_user
      end
    end

    context 'without authentication' do
      it 'returns unauthorized error' do
        get '/api/v1/users'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/v1/users/:id' do
    context 'with authenticated user' do
      it 'returns the specified user' do
        get "/api/v1/users/#{other_user.id}", headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('User retrieved successfully')
        expect(json_response['data']['id']).to eq(other_user.id)
        expect(json_response['data']['email']).to eq(other_user.email)
      end

      it 'returns not found for non-existent user' do
        get '/api/v1/users/99999', headers: auth_headers(user)
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'without authentication' do
      it 'returns unauthorized error' do
        get "/api/v1/users/#{other_user.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT /api/v1/users/:id' do
    let(:valid_params) do
      {
        user: {
          first_name: 'Updated',
          last_name: 'Name',
          phone: '+1-555-987-6543',
          address: '456 Updated St, City',
          bio: 'Updated bio',
          employment_status: 'freelancer',
          about: 'Updated about section'
        }
      }
    end

    context 'with authenticated user' do
      it 'updates the user profile' do
        put "/api/v1/users/#{user.id}", params: valid_params, headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('User updated successfully')
        expect(json_response['data']['first_name']).to eq('Updated')
        expect(json_response['data']['last_name']).to eq('Name')
        expect(json_response['data']['employment_status']).to eq('freelancer')
      end

      it 'returns validation errors for invalid params' do
        invalid_params = {
          user: {
            first_name: '', # Invalid: too short
            last_name: 'A'  # Invalid: too short
          }
        }

        put "/api/v1/users/#{user.id}", params: invalid_params, headers: auth_headers(user)

        expect(response).to have_http_status(:unprocessable_entity)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to eq('Update failed')
        expect(json_response['errors']).to be_present
      end

      it 'returns not found for non-existent user' do
        put '/api/v1/users/99999', params: valid_params, headers: auth_headers(user)
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'without authentication' do
      it 'returns unauthorized error' do
        put "/api/v1/users/#{user.id}", params: valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/v1/users/profile' do
    context 'with authenticated user' do
      it 'returns current user profile' do
        get '/api/v1/users/profile', headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('Profile retrieved successfully')
        expect(json_response['data']['id']).to eq(user.id)
        expect(json_response['data']['email']).to eq(user.email)
        expect(json_response['data']['full_name']).to eq(user.full_name)
      end
    end

    context 'without authentication' do
      it 'returns unauthorized error' do
        get '/api/v1/users/profile'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/v1/users/matches' do
    context 'with authenticated user' do
      it 'returns message about functionality being moved' do
        get '/api/v1/users/matches', headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('Matches functionality moved to matching controller')
      end
    end

    context 'without authentication' do
      it 'returns unauthorized error' do
        get '/api/v1/users/matches'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end 