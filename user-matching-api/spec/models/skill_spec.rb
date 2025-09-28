require 'rails_helper'

RSpec.describe Skill, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:value) }
    it { should validate_presence_of(:category) }
    it { should validate_presence_of(:rating) }
    it { should validate_length_of(:value).is_at_least(2).is_at_most(100) }
    it { should validate_length_of(:category).is_at_least(2).is_at_most(50) }
    it { should validate_inclusion_of(:rating).in_range(1..5) }
    it { should validate_inclusion_of(:category).in_array(Skill::CATEGORIES) }
  end

  describe 'scopes' do
    let(:user) { create(:user) }
    let!(:programming_skill) { create(:skill, :programming, user: user) }
    let!(:design_skill) { create(:skill, :design, user: user) }
    let!(:high_rated_skill) { create(:skill, :high_rated, user: user) }

    describe '.by_category' do
      it 'filters skills by category' do
        expect(Skill.by_category('programming')).to include(programming_skill)
        expect(Skill.by_category('programming')).not_to include(design_skill)
      end
    end

    describe '.high_rated' do
      it 'returns skills with rating 4 or 5' do
        expect(Skill.high_rated).to include(high_rated_skill)
        expect(Skill.high_rated).not_to include(create(:skill, :low_rated, user: user))
      end
    end

    describe '.ordered_by_rating' do
      it 'orders skills by rating in descending order' do
        low_rated = create(:skill, :low_rated, user: user)
        skills = Skill.ordered_by_rating
        expect(skills.first.rating).to be >= skills.last.rating
      end
    end
  end

  describe 'instance methods' do
    describe '#proficiency_level' do
      it 'returns correct proficiency level for rating 1' do
        skill = build(:skill, rating: 1)
        expect(skill.proficiency_level).to eq('Beginner')
      end

      it 'returns correct proficiency level for rating 2' do
        skill = build(:skill, rating: 2)
        expect(skill.proficiency_level).to eq('Elementary')
      end

      it 'returns correct proficiency level for rating 3' do
        skill = build(:skill, rating: 3)
        expect(skill.proficiency_level).to eq('Intermediate')
      end

      it 'returns correct proficiency level for rating 4' do
        skill = build(:skill, rating: 4)
        expect(skill.proficiency_level).to eq('Advanced')
      end

      it 'returns correct proficiency level for rating 5' do
        skill = build(:skill, rating: 5)
        expect(skill.proficiency_level).to eq('Expert')
      end
    end
  end

  describe 'constants' do
    it 'defines valid categories' do
      expect(Skill::CATEGORIES).to include(
        'programming', 'design', 'marketing', 'business', 'soft_skills',
        'languages', 'tools', 'frameworks', 'databases'
      )
    end
  end

  describe 'rating validation' do
    it 'accepts valid ratings' do
      (1..5).each do |rating|
        skill = build(:skill, rating: rating)
        expect(skill).to be_valid
      end
    end

    it 'rejects invalid ratings' do
      [0, 6, -1].each do |rating|
        skill = build(:skill, rating: rating)
        expect(skill).not_to be_valid
        expect(skill.errors[:rating]).to include('is not included in the list')
      end
    end
  end
end
