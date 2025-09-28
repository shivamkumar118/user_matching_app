require 'rails_helper'

RSpec.describe 'Api::V1::Matching', type: :request do
  let(:user1) { create(:user, :with_complete_profile) }
  let(:user2) { create(:user, :with_complete_profile) }
  let(:user3) { create(:user, :with_complete_profile) }

  before do
    # Create some questions and answers for testing
    @question1 = create(:question, :professional)
    @question2 = create(:question, :personal)
    @question3 = create(:question, :lifestyle)

    # User1 answers
    create(:answer, user: user1, question: @question1, answer_text: 'I prefer collaborative environments')
    create(:answer, user: user1, question: @question2, answer_text: 'I handle stress by taking breaks')
    
    # User2 answers (similar to user1)
    create(:answer, user: user2, question: @question1, answer_text: 'I enjoy working in teams and collaborative settings')
    create(:answer, user: user2, question: @question2, answer_text: 'I manage stress by taking regular breaks')
    
    # User3 answers (different from user1)
    create(:answer, user: user3, question: @question1, answer_text: 'I prefer working alone in quiet environments')
    create(:answer, user: user3, question: @question2, answer_text: 'I handle stress by working harder')

    # Create skills for users
    create(:skill, :programming, user: user1, value: 'Ruby', rating: 5)
    create(:skill, :frameworks, user: user1, value: 'Rails', rating: 4)
    
    create(:skill, :programming, user: user2, value: 'Ruby', rating: 4)
    create(:skill, :frameworks, user: user2, value: 'Rails', rating: 5)
    
    create(:skill, :programming, user: user3, value: 'Python', rating: 5)
    create(:skill, :frameworks, user: user3, value: 'Django', rating: 4)

    # Create experiences for users
    create(:experience, :software_engineer, user: user1, company_name: 'TechCorp')
    create(:experience, :software_engineer, user: user2, company_name: 'TechCorp')
    create(:experience, :data_scientist, user: user3, company_name: 'DataCorp')
  end

  describe 'GET /api/v1/matching/users' do
    context 'with authenticated user' do
      it 'returns users with match scores' do
        get '/api/v1/matching/users', headers: auth_headers(user1)

        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['data']['users']).to be_an(Array)
        expect(json_response['data']['users'].length).to eq(2) # user2 and user3
        
        # Check that users are sorted by match score (highest first)
        users = json_response['data']['users']
        expect(users.first['match_score']).to be >= users.last['match_score']
        
        # Check that match scores are between 0 and 1
        users.each do |user_data|
          expect(user_data['match_score']).to be_between(0, 1)
          expect(user_data['match_percentage']).to be_between(0, 100)
        end
      end

      it 'excludes current user from results' do
        get '/api/v1/matching/users', headers: auth_headers(user1)

        json_response = JSON.parse(response.body)
        user_ids = json_response['data']['users'].map { |u| u['user']['id'] }
        expect(user_ids).not_to include(user1.id)
      end
    end

    context 'without authentication' do
      it 'returns unauthorized error' do
        get '/api/v1/matching/users'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/v1/matching/calculate/:user_id' do
    context 'with authenticated user' do
      it 'calculates match score between current user and target user' do
        get "/api/v1/matching/calculate/#{user2.id}", headers: auth_headers(user1)

        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['data']['user']['id']).to eq(user2.id)
        expect(json_response['data']['match_score']).to be_between(0, 1)
        expect(json_response['data']['match_percentage']).to be_between(0, 100)
        expect(json_response['data']['breakdown']).to be_present
      end

      it 'includes breakdown of matching components' do
        get "/api/v1/matching/calculate/#{user2.id}", headers: auth_headers(user1)

        json_response = JSON.parse(response.body)
        breakdown = json_response['data']['breakdown']
        
        expect(breakdown).to include('answer_similarity')
        expect(breakdown).to include('skill_similarity')
        expect(breakdown).to include('experience_similarity')
        expect(breakdown).to include('profile_completion_similarity')
        
        # All breakdown scores should be between 0 and 1
        breakdown.values.each do |score|
          expect(score).to be_between(0, 1)
        end
      end

      it 'returns higher match score for similar users' do
        # Get match score with user2 (similar to user1)
        get "/api/v1/matching/calculate/#{user2.id}", headers: auth_headers(user1)
        json_response1 = JSON.parse(response.body)
        score_with_user2 = json_response1['data']['match_score']

        # Get match score with user3 (different from user1)
        get "/api/v1/matching/calculate/#{user3.id}", headers: auth_headers(user1)
        json_response2 = JSON.parse(response.body)
        score_with_user3 = json_response2['data']['match_score']

        # user2 should have higher match score than user3
        expect(score_with_user2).to be > score_with_user3
      end
    end

    context 'with non-existent user' do
      it 'returns not found error' do
        get '/api/v1/matching/calculate/99999', headers: auth_headers(user1)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET /api/v1/matching/compatibility/:user_id/:other_user_id' do
    context 'with authenticated user' do
      it 'calculates compatibility between two specified users' do
        get "/api/v1/matching/compatibility/#{user1.id}/#{user2.id}", headers: auth_headers(user1)

        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['data']['user1']['id']).to eq(user1.id)
        expect(json_response['data']['user2']['id']).to eq(user2.id)
        expect(json_response['data']['match_score']).to be_between(0, 1)
        expect(json_response['data']['match_percentage']).to be_between(0, 100)
      end

      it 'returns same score regardless of user order' do
        get "/api/v1/matching/compatibility/#{user1.id}/#{user2.id}", headers: auth_headers(user1)
        json_response1 = JSON.parse(response.body)
        score1 = json_response1['data']['match_score']

        get "/api/v1/matching/compatibility/#{user2.id}/#{user1.id}", headers: auth_headers(user1)
        json_response2 = JSON.parse(response.body)
        score2 = json_response2['data']['match_score']

        expect(score1).to eq(score2)
      end
    end

    context 'with non-existent users' do
      it 'returns not found error' do
        get '/api/v1/matching/compatibility/99999/88888', headers: auth_headers(user1)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
