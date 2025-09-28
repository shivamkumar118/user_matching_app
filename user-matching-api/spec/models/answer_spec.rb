require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:question) }
  end

  describe 'validations' do
    subject { build(:answer) }
    
    it { should validate_presence_of(:answer_text) }
    it { should validate_length_of(:answer_text).is_at_least(5).is_at_most(1000) }
    
    it 'validates uniqueness of user_id scoped to question_id' do
      user = create(:user)
      question = create(:question)
      create(:answer, user: user, question: question)
      
      duplicate_answer = build(:answer, user: user, question: question)
      expect(duplicate_answer).not_to be_valid
      expect(duplicate_answer.errors[:user_id]).to include('has already answered this question')
    end
  end

  describe 'scopes' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let!(:answer) { create(:answer, user: user, question: question) }

    describe '.by_question' do
      it 'filters answers by question' do
        expect(Answer.by_question(question)).to include(answer)
      end
    end

    describe '.by_user' do
      it 'filters answers by user' do
        expect(Answer.by_user(user)).to include(answer)
      end
    end
  end

  describe 'instance methods' do
    let(:user) { create(:user, first_name: 'John', last_name: 'Doe') }
    let(:question) { create(:question, title: 'Test Question', category: 'professional') }
    let(:answer) { create(:answer, user: user, question: question) }

    describe '#question_title' do
      it 'returns the question title' do
        expect(answer.question_title).to eq('Test Question')
      end
    end

    describe '#question_category' do
      it 'returns the question category' do
        expect(answer.question_category).to eq('professional')
      end
    end

    describe '#user_name' do
      it 'returns the user full name' do
        expect(answer.user_name).to eq('John Doe')
      end
    end
  end

  describe 'uniqueness validation' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let!(:existing_answer) { create(:answer, user: user, question: question) }

    it 'prevents duplicate answers from same user for same question' do
      duplicate_answer = build(:answer, user: user, question: question)
      expect(duplicate_answer).not_to be_valid
      expect(duplicate_answer.errors[:user_id]).to include('has already answered this question')
    end

    it 'allows different users to answer the same question' do
      other_user = create(:user)
      other_answer = build(:answer, user: other_user, question: question)
      expect(other_answer).to be_valid
    end

    it 'allows same user to answer different questions' do
      other_question = create(:question)
      other_answer = build(:answer, user: user, question: other_question)
      expect(other_answer).to be_valid
    end
  end
end
