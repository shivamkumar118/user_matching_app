require 'rails_helper'

RSpec.describe 'Api::V1::Questions', type: :request do
  let(:user) { create(:user, :with_complete_profile) }
  let!(:professional_question) { create(:question, :professional) }
  let!(:personal_question) { create(:question, :personal) }
  let!(:lifestyle_question) { create(:question, :lifestyle) }

  describe 'GET /api/v1/questions' do
    context 'with authenticated user' do
      it 'returns all questions ordered by category' do
        get '/api/v1/questions', headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('Questions retrieved successfully')
        expect(json_response['data']).to be_an(Array)
        expect(json_response['data'].length).to eq(3)
        
        # Check that questions are ordered by category
        questions = json_response['data']
        expect(questions.first['category']).to be <= questions.last['category']
      end

      it 'includes question attributes' do
        get '/api/v1/questions', headers: auth_headers(user)

        json_response = JSON.parse(response.body)
        question = json_response['data'].first
        
        expect(question).to include('id', 'title', 'category', 'created_at', 'updated_at')
        expect(question['title']).to be_present
        expect(question['category']).to be_present
      end
    end

    context 'without authentication' do
      it 'returns unauthorized error' do
        get '/api/v1/questions'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    context 'with authenticated user' do
      it 'returns the specified question' do
        get "/api/v1/questions/#{professional_question.id}", headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('Question retrieved successfully')
        expect(json_response['data']['id']).to eq(professional_question.id)
        expect(json_response['data']['title']).to eq(professional_question.title)
        expect(json_response['data']['category']).to eq(professional_question.category)
      end

      it 'returns not found for non-existent question' do
        get '/api/v1/questions/99999', headers: auth_headers(user)
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'without authentication' do
      it 'returns unauthorized error' do
        get "/api/v1/questions/#{professional_question.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end 