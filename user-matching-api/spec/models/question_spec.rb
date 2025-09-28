require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
  end

  describe 'validations' do
    subject { build(:question) }
    
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:category) }
    it { should validate_uniqueness_of(:title) }
    it { should validate_length_of(:title).is_at_least(10).is_at_most(500) }
    it { should validate_length_of(:category).is_at_least(2).is_at_most(50) }
    it { should validate_inclusion_of(:category).in_array(Question::CATEGORIES) }
  end

  describe 'scopes' do
    let!(:professional_question) { create(:question, :professional) }
    let!(:personal_question) { create(:question, :personal) }
    let!(:lifestyle_question) { create(:question, :lifestyle) }

    describe '.by_category' do
      it 'filters questions by category' do
        expect(Question.by_category('professional')).to include(professional_question)
        expect(Question.by_category('professional')).not_to include(personal_question)
      end
    end

    describe '.ordered_by_category' do
      it 'orders questions by category and title' do
        questions = Question.ordered_by_category
        expect(questions.first.category).to be <= questions.last.category
      end
    end
  end

  describe 'instance methods' do
    let(:question) { create(:question) }
    let(:user) { create(:user) }

    describe '#answered_by_user?' do
      context 'when user has answered the question' do
        let!(:answer) { create(:answer, question: question, user: user) }

        it 'returns true' do
          expect(question.answered_by_user?(user)).to be true
        end
      end

      context 'when user has not answered the question' do
        it 'returns false' do
          expect(question.answered_by_user?(user)).to be false
        end
      end
    end

    describe '#user_answer' do
      context 'when user has answered the question' do
        let!(:answer) { create(:answer, question: question, user: user) }

        it 'returns the user answer' do
          expect(question.user_answer(user)).to eq(answer)
        end
      end

      context 'when user has not answered the question' do
        it 'returns nil' do
          expect(question.user_answer(user)).to be_nil
        end
      end
    end

    describe '#answer_count' do
      context 'with multiple answers' do
        let!(:answer1) { create(:answer, question: question) }
        let!(:answer2) { create(:answer, question: question) }

        it 'returns the correct count' do
          expect(question.answer_count).to eq(2)
        end
      end

      context 'with no answers' do
        it 'returns zero' do
          expect(question.answer_count).to eq(0)
        end
      end
    end
  end

  describe 'constants' do
    it 'defines valid categories' do
      expect(Question::CATEGORIES).to include('personal', 'professional', 'lifestyle', 'values', 'goals', 'preferences')
    end
  end
end
