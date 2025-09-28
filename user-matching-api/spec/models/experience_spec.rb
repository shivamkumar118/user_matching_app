require 'rails_helper'

RSpec.describe Experience, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:job_title) }
    it { should validate_presence_of(:company_name) }
    it { should validate_presence_of(:start_date) }
    it { should validate_length_of(:job_title).is_at_least(2).is_at_most(100) }
    it { should validate_length_of(:company_name).is_at_least(2).is_at_most(100) }
    it { should validate_length_of(:description).is_at_most(1000) }
  end

  describe 'date validations' do
    let(:experience) { build(:experience) }

    it 'validates end_date is after start_date' do
      experience.start_date = Date.current
      experience.end_date = 1.day.ago
      expect(experience).not_to be_valid
      expect(experience.errors[:end_date]).to include("must be greater than #{Date.current}")
    end

    it 'allows end_date to be nil (current position)' do
      experience.end_date = nil
      expect(experience).to be_valid
    end

    it 'allows end_date to be after start_date' do
      experience.start_date = 1.year.ago
      experience.end_date = Date.current
      expect(experience).to be_valid
    end
  end

  describe 'scopes' do
    let(:user) { create(:user) }
    let!(:current_experience) { create(:experience, :current, user: user) }
    let!(:past_experience) { create(:experience, :past, user: user) }

    describe '.current' do
      it 'returns experiences with no end_date' do
        expect(Experience.current).to include(current_experience)
        expect(Experience.current).not_to include(past_experience)
      end
    end

    describe '.past' do
      it 'returns experiences with end_date' do
        expect(Experience.past).to include(past_experience)
        expect(Experience.past).not_to include(current_experience)
      end
    end

    describe '.ordered_by_start_date' do
      it 'orders experiences by start_date in descending order' do
        experiences = Experience.ordered_by_start_date
        expect(experiences.first.start_date).to be >= experiences.last.start_date
      end
    end
  end

  describe 'instance methods' do
    let(:user) { create(:user) }

    describe '#duration_in_months' do
      it 'calculates duration for past experience' do
        experience = create(:experience, 
          user: user,
          start_date: Date.new(2020, 1, 1),
          end_date: Date.new(2021, 1, 1)
        )
        expect(experience.duration_in_months).to eq(12)
      end

      it 'calculates duration for current experience' do
        experience = create(:experience, 
          user: user,
          start_date: 6.months.ago,
          end_date: nil
        )
        expect(experience.duration_in_months).to be >= 6
      end
    end

    describe '#duration_text' do
      it 'formats duration in months correctly' do
        experience = create(:experience, 
          user: user,
          start_date: Date.new(2020, 1, 1),
          end_date: Date.new(2020, 3, 1)
        )
        expect(experience.duration_text).to eq('2 months')
      end

      it 'formats duration in years correctly' do
        experience = create(:experience, 
          user: user,
          start_date: Date.new(2020, 1, 1),
          end_date: Date.new(2022, 1, 1)
        )
        expect(experience.duration_text).to eq('2 years')
      end

      it 'formats duration in years and months correctly' do
        experience = create(:experience, 
          user: user,
          start_date: Date.new(2020, 1, 1),
          end_date: Date.new(2021, 3, 1)
        )
        expect(experience.duration_text).to eq('1 year 2 months')
      end
    end

    describe '#is_current?' do
      it 'returns true for current experience' do
        experience = create(:experience, :current, user: user)
        expect(experience.is_current?).to be true
      end

      it 'returns false for past experience' do
        experience = create(:experience, :past, user: user)
        expect(experience.is_current?).to be false
      end
    end
  end
end
