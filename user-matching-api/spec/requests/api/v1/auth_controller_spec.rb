require 'rails_helper'

RSpec.describe 'Api::V1::Auth', type: :request do
  describe 'POST /api/v1/auth/register' do
    let(:valid_params) do
      {
        user: {
          email: 'test@example.com',
          password: 'password123',
          password_confirmation: 'password123',
          first_name: 'John',
          last_name: 'Doe',
          phone: '+1-555-123-4567',
          address: '123 Test St, Test City',
          bio: 'Test bio',
          employment_status: 'employed',
          about: 'Test about'
        }
      }
    end

    context 'with valid parameters' do
      it 'creates a new user and returns token' do
        expect {
          post '/api/v1/auth/register', params: valid_params
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('User registered successfully')
        expect(json_response['data']['user']['email']).to eq('test@example.com')
        expect(json_response['data']['token']).to be_present
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          user: {
            email: 'invalid-email',
            password: 'short',
            password_confirmation: 'different',
            first_name: '',
            last_name: ''
          }
        }
      end

      it 'returns validation errors' do
        post '/api/v1/auth/register', params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to eq('Registration failed')
        expect(json_response['errors']).to be_present
      end
    end

    context 'with duplicate email' do
      let!(:existing_user) { create(:user, email: 'test@example.com') }

      it 'returns error for duplicate email' do
        post '/api/v1/auth/register', params: valid_params

        expect(response).to have_http_status(:unprocessable_entity)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['errors']).to include('Email has already been taken')
      end
    end
  end

  describe 'POST /api/v1/auth/login' do
    let!(:user) { create(:user, email: 'test@example.com', password: 'password123') }

    context 'with valid credentials' do
      let(:valid_params) do
        {
          email: 'test@example.com',
          password: 'password123'
        }
      end

      it 'returns user data and token' do
        post '/api/v1/auth/login', params: valid_params

        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('Login successful')
        expect(json_response['data']['user']['email']).to eq('test@example.com')
        expect(json_response['data']['token']).to be_present
      end
    end

    context 'with invalid email' do
      let(:invalid_params) do
        {
          email: 'wrong@example.com',
          password: 'password123'
        }
      end

      it 'returns unauthorized error' do
        post '/api/v1/auth/login', params: invalid_params

        expect(response).to have_http_status(:unauthorized)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to eq('Invalid email or password')
      end
    end

    context 'with invalid password' do
      let(:invalid_params) do
        {
          email: 'test@example.com',
          password: 'wrongpassword'
        }
      end

      it 'returns unauthorized error' do
        post '/api/v1/auth/login', params: invalid_params

        expect(response).to have_http_status(:unauthorized)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to eq('Invalid email or password')
      end
    end
  end

  describe 'POST /api/v1/auth/logout' do
    let(:user) { create(:user) }

    context 'with valid token' do
      it 'returns success message' do
        post '/api/v1/auth/logout', headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('Logged out successfully')
      end
    end

    context 'without token' do
      it 'returns unauthorized error' do
        post '/api/v1/auth/logout'

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
