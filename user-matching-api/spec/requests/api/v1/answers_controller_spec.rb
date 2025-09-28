require 'rails_helper'

RSpec.describe 'Api::V1::Answers', type: :request do
  let(:user) { create(:user, :with_complete_profile) }
  let(:question) { create(:question, :professional) }
  let!(:existing_answer) { create(:answer, user: user, question: question) }
  let(:other_question) { create(:question, :personal) }

  describe 'GET /api/v1/answers' do
    context 'with authenticated user' do
      it 'returns user answers' do
        get '/api/v1/answers', headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('Answers retrieved successfully')
        expect(json_response['data']).to be_an(Array)
        expect(json_response['data'].length).to eq(1)
        expect(json_response['data'].first['id']).to eq(existing_answer.id)
      end

      it 'includes answer attributes' do
        get '/api/v1/answers', headers: auth_headers(user)

        json_response = JSON.parse(response.body)
        answer = json_response['data'].first
        
        expect(answer).to include('id', 'answer_text', 'question_title', 'question_category', 'created_at', 'updated_at')
        expect(answer['answer_text']).to eq(existing_answer.answer_text)
        expect(answer['question_title']).to eq(existing_answer.question_title)
      end
    end

    context 'without authentication' do
      it 'returns unauthorized error' do
        get '/api/v1/answers'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /api/v1/answers' do
    let(:valid_params) do
      {
        answer: {
          question_id: other_question.id,
          answer_text: 'This is my answer to the question.'
        }
      }
    end

    context 'with authenticated user' do
      it 'creates a new answer' do
        expect {
          post '/api/v1/answers', params: valid_params, headers: auth_headers(user)
        }.to change(Answer, :count).by(1)

        expect(response).to have_http_status(:created)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('Answer created successfully')
        expect(json_response['data']['answer_text']).to eq('This is my answer to the question.')
        expect(json_response['data']['question_title']).to eq(other_question.title)
      end

      it 'returns validation errors for invalid params' do
        invalid_params = {
          answer: {
            question_id: other_question.id,
            answer_text: 'Hi' # Too short
          }
        }

        post '/api/v1/answers', params: invalid_params, headers: auth_headers(user)

        expect(response).to have_http_status(:unprocessable_entity)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to eq('Answer creation failed')
        expect(json_response['errors']).to be_present
      end

      it 'prevents duplicate answers for same question' do
        duplicate_params = {
          answer: {
            question_id: question.id, # Same question as existing_answer
            answer_text: 'Another answer to the same question.'
          }
        }

        post '/api/v1/answers', params: duplicate_params, headers: auth_headers(user)

        expect(response).to have_http_status(:unprocessable_entity)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to eq('Answer creation failed')
      end
    end

    context 'without authentication' do
      it 'returns unauthorized error' do
        post '/api/v1/answers', params: valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT /api/v1/answers/:id' do
    let(:valid_params) do
      {
        answer: {
          answer_text: 'Updated answer text with more content.'
        }
      }
    end

    context 'with authenticated user' do
      it 'updates the answer' do
        put "/api/v1/answers/#{existing_answer.id}", params: valid_params, headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('Answer updated successfully')
        expect(json_response['data']['answer_text']).to eq('Updated answer text with more content.')
      end

      it 'returns validation errors for invalid params' do
        invalid_params = {
          answer: {
            answer_text: 'Hi' # Too short
          }
        }

        put "/api/v1/answers/#{existing_answer.id}", params: invalid_params, headers: auth_headers(user)

        expect(response).to have_http_status(:unprocessable_entity)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to eq('Answer update failed')
        expect(json_response['errors']).to be_present
      end

      it 'returns not found for non-existent answer' do
        put '/api/v1/answers/99999', params: valid_params, headers: auth_headers(user)
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'without authentication' do
      it 'returns unauthorized error' do
        put "/api/v1/answers/#{existing_answer.id}", params: valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    context 'with authenticated user' do
      it 'deletes the answer' do
        expect {
          delete "/api/v1/answers/#{existing_answer.id}", headers: auth_headers(user)
        }.to change(Answer, :count).by(-1)

        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('Answer deleted successfully')
      end

      it 'returns not found for non-existent answer' do
        delete '/api/v1/answers/99999', headers: auth_headers(user)
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'without authentication' do
      it 'returns unauthorized error' do
        delete "/api/v1/answers/#{existing_answer.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end 