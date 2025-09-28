require 'rails_helper'

RSpec.describe 'Api::V1::Experiences', type: :request do
  let(:user) { create(:user, :with_complete_profile) }
  let!(:current_experience) { create(:experience, :current, user: user, job_title: 'Software Engineer', company_name: 'TechCorp') }
  let!(:past_experience) { create(:experience, :past, user: user, job_title: 'Junior Developer', company_name: 'StartupInc') }

  describe 'GET /api/v1/experiences' do
    context 'with authenticated user' do
      it 'returns user experiences ordered by start date' do
        get '/api/v1/experiences', headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('Experiences retrieved successfully')
        expect(json_response['data']).to be_an(Array)
        expect(json_response['data'].length).to eq(2)
        
        # Check that experiences are ordered by start date (newest first)
        experiences = json_response['data']
        expect(experiences.first['start_date']).to be >= experiences.last['start_date']
      end

      it 'includes experience attributes' do
        get '/api/v1/experiences', headers: auth_headers(user)

        json_response = JSON.parse(response.body)
        experience = json_response['data'].first
        
        expect(experience).to include('id', 'job_title', 'company_name', 'start_date', 'end_date', 'description', 'duration_text', 'is_current', 'created_at', 'updated_at')
        expect(experience['job_title']).to be_present
        expect(experience['company_name']).to be_present
        expect(experience['start_date']).to be_present
        expect(experience['is_current']).to be_in([true, false])
      end

      it 'shows current experience correctly' do
        get '/api/v1/experiences', headers: auth_headers(user)

        json_response = JSON.parse(response.body)
        current_exp = json_response['data'].find { |exp| exp['job_title'] == 'Software Engineer' }
        
        expect(current_exp['is_current']).to be true
        expect(current_exp['end_date']).to be_nil
      end

      it 'shows past experience correctly' do
        get '/api/v1/experiences', headers: auth_headers(user)

        json_response = JSON.parse(response.body)
        past_exp = json_response['data'].find { |exp| exp['job_title'] == 'Junior Developer' }
        
        expect(past_exp['is_current']).to be false
        expect(past_exp['end_date']).to be_present
      end
    end

    context 'without authentication' do
      it 'returns unauthorized error' do
        get '/api/v1/experiences'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /api/v1/experiences' do
    let(:valid_params) do
      {
        experience: {
          job_title: 'Senior Developer',
          company_name: 'BigTech Inc',
          start_date: '2023-01-01',
          description: 'Leading development team and mentoring junior developers.'
        }
      }
    end

    context 'with authenticated user' do
      it 'creates a new current experience' do
        expect {
          post '/api/v1/experiences', params: valid_params, headers: auth_headers(user)
        }.to change(Experience, :count).by(1)

        expect(response).to have_http_status(:created)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('Experience created successfully')
        expect(json_response['data']['job_title']).to eq('Senior Developer')
        expect(json_response['data']['company_name']).to eq('BigTech Inc')
        expect(json_response['data']['is_current']).to be true
        expect(json_response['data']['end_date']).to be_nil
      end

      it 'creates a past experience with end date' do
        past_params = {
          experience: {
            job_title: 'Frontend Developer',
            company_name: 'WebCorp',
            start_date: '2022-01-01',
            end_date: '2022-12-31',
            description: 'Built responsive web applications using modern frameworks.'
          }
        }

        post '/api/v1/experiences', params: past_params, headers: auth_headers(user)

        expect(response).to have_http_status(:created)
        
        json_response = JSON.parse(response.body)
        expect(json_response['data']['is_current']).to be false
        expect(json_response['data']['end_date']).to eq('2022-12-31')
        expect(json_response['data']['duration_text']).to eq('11 months')
      end

      it 'returns validation errors for invalid params' do
        invalid_params = {
          experience: {
            job_title: 'A', # Too short
            company_name: '', # Empty
            start_date: '2023-01-01',
            end_date: '2022-01-01' # End date before start date
          }
        }

        post '/api/v1/experiences', params: invalid_params, headers: auth_headers(user)

        expect(response).to have_http_status(:unprocessable_entity)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to eq('Experience creation failed')
        expect(json_response['errors']).to be_present
      end
    end

    context 'without authentication' do
      it 'returns unauthorized error' do
        post '/api/v1/experiences', params: valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT /api/v1/experiences/:id' do
    let(:valid_params) do
      {
        experience: {
          job_title: 'Lead Software Engineer',
          description: 'Updated description with more responsibilities.'
        }
      }
    end

    context 'with authenticated user' do
      it 'updates the experience' do
        put "/api/v1/experiences/#{current_experience.id}", params: valid_params, headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('Experience updated successfully')
        expect(json_response['data']['job_title']).to eq('Lead Software Engineer')
        expect(json_response['data']['description']).to eq('Updated description with more responsibilities.')
      end

      it 'can update current experience to past experience' do
        update_params = {
          experience: {
            end_date: Date.current.to_s
          }
        }

        put "/api/v1/experiences/#{current_experience.id}", params: update_params, headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response['data']['is_current']).to be false
        expect(json_response['data']['end_date']).to be_present
      end

      it 'returns validation errors for invalid params' do
        invalid_params = {
          experience: {
            job_title: '', # Empty
            end_date: '2020-01-01' # End date before start date
          }
        }

        put "/api/v1/experiences/#{current_experience.id}", params: invalid_params, headers: auth_headers(user)

        expect(response).to have_http_status(:unprocessable_entity)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to eq('Experience update failed')
        expect(json_response['errors']).to be_present
      end

      it 'returns not found for non-existent experience' do
        put '/api/v1/experiences/99999', params: valid_params, headers: auth_headers(user)
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'without authentication' do
      it 'returns unauthorized error' do
        put "/api/v1/experiences/#{current_experience.id}", params: valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/v1/experiences/:id' do
    context 'with authenticated user' do
      it 'deletes the experience' do
        expect {
          delete "/api/v1/experiences/#{current_experience.id}", headers: auth_headers(user)
        }.to change(Experience, :count).by(-1)

        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('Experience deleted successfully')
      end

      it 'returns not found for non-existent experience' do
        delete '/api/v1/experiences/99999', headers: auth_headers(user)
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'without authentication' do
      it 'returns unauthorized error' do
        delete "/api/v1/experiences/#{current_experience.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end 