require 'rails_helper'

RSpec.describe UserSerializer, type: :serializer do
  let(:user) { create(:user, :with_complete_profile) }
  let(:serializer) { UserSerializer.new(user) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }
  let(:json) { JSON.parse(serialization.to_json) }

  describe 'attributes' do
    it 'includes all required attributes' do
      expect(json['id']).to eq(user.id)
      expect(json['email']).to eq(user.email)
      expect(json['first_name']).to eq(user.first_name)
      expect(json['last_name']).to eq(user.last_name)
      expect(json['full_name']).to eq(user.full_name)
      expect(json['phone']).to eq(user.phone)
      expect(json['address']).to eq(user.address)
      expect(json['bio']).to eq(user.bio)
      expect(json['employment_status']).to eq(user.employment_status)
      expect(json['about']).to eq(user.about)
      expect(json['profile_completion_percentage']).to eq(user.profile_completion_percentage)
      expect(json['has_answered_questions']).to eq(user.has_answered_questions?)
      expect(json['has_skills']).to eq(user.has_skills?)
      expect(json['has_experience']).to eq(user.has_experience?)
      expect(json['created_at']).to be_present
      expect(json['updated_at']).to be_present
    end
  end

  describe 'associations' do
    let!(:experience) { create(:experience, user: user) }
    let!(:skill) { create(:skill, user: user) }
    let!(:answer) { create(:answer, user: user) }

    it 'includes experiences' do
      expect(json['experiences']).to be_an(Array)
      expect(json['experiences'].length).to eq(1)
      expect(json['experiences'].first['id']).to eq(experience.id)
    end

    it 'includes skills' do
      expect(json['skills']).to be_an(Array)
      expect(json['skills'].length).to eq(1)
      expect(json['skills'].first['id']).to eq(skill.id)
    end

    it 'includes answers' do
      expect(json['answers']).to be_an(Array)
      expect(json['answers'].length).to eq(1)
      expect(json['answers'].first['id']).to eq(answer.id)
    end
  end

  describe 'computed attributes' do
    it 'calculates full_name correctly' do
      expect(json['full_name']).to eq("#{user.first_name} #{user.last_name}")
    end

    it 'calculates profile_completion_percentage correctly' do
      expect(json['profile_completion_percentage']).to be_between(0, 100)
    end

    it 'returns correct boolean flags' do
      expect(json['has_answered_questions']).to be_in([true, false])
      expect(json['has_skills']).to be_in([true, false])
      expect(json['has_experience']).to be_in([true, false])
    end
  end

  describe 'with associations' do
    let!(:experience) { create(:experience, user: user) }
    let!(:skill) { create(:skill, user: user) }
    let!(:answer) { create(:answer, user: user) }
    let(:serializer_with_associations) { UserSerializer.new(user, include: [:experiences, :skills, :answers]) }
    let(:serialization_with_associations) { ActiveModelSerializers::Adapter.create(serializer_with_associations) }
    let(:json_with_associations) { JSON.parse(serialization_with_associations.to_json) }

    it 'includes nested association data' do
      expect(json_with_associations['experiences'].first).to include('job_title', 'company_name')
      expect(json_with_associations['skills'].first).to include('value', 'category', 'rating')
      expect(json_with_associations['answers'].first).to include('answer_text', 'question_title')
    end
  end
end 