require 'rails_helper'

RSpec.describe UserProfile, type: :model do
  it { should have_many(:profile_images) }
  it { should belong_to(:user) }
  it { should belong_to(:project) }

  it { should validate_length_of(:answer_name).is_at_most(30) }
  it { should validate_numericality_of(:group_id) }
  it { should validate_numericality_of(:joined_year) }
  it { should validate_length_of(:detail).is_at_most(10000) }

  describe 'Scopes' do
    describe '.without_user' do
      let(:target_user_profiles)    { FactoryGirl.create_list :user_profile, 10 }
      let(:untargeted_user_profile) { FactoryGirl.create :user_profile }

      subject { described_class.without_user(untargeted_user_profile.user_id) }

      it 'collects target_user_profiles ' do
        expect(subject).to match_array target_user_profiles
      end
    end

    describe '.with_image' do
      let(:has_image_user_profiles)   { FactoryGirl.create_list :user_profile, 10 }
      let(:has_no_image_user_profile) { FactoryGirl.create_list :user_profile, 10, profile_image: nil }

      subject { described_class.with_image }

      it 'collects has_image_user_profiles ' do
        expect(subject).to match_array has_image_user_profiles
      end
    end

    describe '.with_group' do
      let(:target_group)             { FactoryGirl.create :group }
      let(:target_user_profiles)     { FactoryGirl.create_list :user_profile, 10, group_id: target_group.id }
      let(:untargeted_user_profiles) { FactoryGirl.create_list :user_profile, 10 }

      subject { described_class.with_group(target_group.id) }

      it 'collects target_user_profiles ' do
        expect(subject).to match_array target_user_profiles
      end
    end

    describe '.with_project' do
      let(:target_project)           { FactoryGirl.create :project }
      let(:target_user_profiles)     { FactoryGirl.create_list :user_profile, 10, project_id: target_project.id }
      let(:untargeted_user_profiles) { FactoryGirl.create_list :user_profile, 10 }

      subject { described_class.with_project(target_project.id) }

      it 'collects target_user_profiles ' do
        expect(subject).to match_array target_user_profiles
      end
    end

    describe '.with_joined_year' do
      let(:target_year)              { Time.zone.now.year }
      let(:untargeted_year)          { Time.zone.now.year-1 }
      let(:target_user_profiles)     { FactoryGirl.create_list :user_profile, 10, joined_year: target_year }
      let(:untargeted_user_profiles) { FactoryGirl.create_list :user_profile, 10, joined_year: untargeted_year }

      subject { described_class.with_joined_year(target_year) }

      it 'collects target_user_profiles ' do
        expect(subject).to match_array target_user_profiles
      end
    end
  end
end
