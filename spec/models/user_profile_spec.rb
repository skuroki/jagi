require 'rails_helper'

RSpec.describe UserProfile, type: :model do
  it { should have_many(:profile_images) }
  it { should belong_to(:user) }
  it { should belong_to(:project) }

  it { should have_db_column(:answer_name).of_type(:string) }
  it { should validate_length_of(:answer_name).is_at_most(30) }

  it { should have_db_column(:group_id).of_type(:integer) }
  it { should validate_numericality_of(:group_id) }

  it { should have_db_column(:gender).of_type(:string) }

  it { should have_db_column(:joined_year).of_type(:integer) }
  it { should validate_numericality_of(:joined_year) }

  it { should have_db_column(:detail).of_type(:text) }
  it { should validate_length_of(:detail).is_at_most(10000) }

  describe '.answer_user (condition, user_profile)' do
    let!(:user_profiles) { FactoryGirl.create_list :user_profile, 10, :with_user, :with_group, :with_project }

    context '入社年度でフィルタする場合' do
      let(:filter_joined_year)  { user_profiles.sample.joined_year }
      let(:answer_user_profile) { UserProfile.answer_user({'joined_year' => filter_joined_year }) }

      it 'condition { joined_year => $joined_year }' do
        expect(answer_user_profile.joined_year).to eq filter_joined_year
      end
    end

    context '所属プロジェクトでフィルタする場合' do
      let(:filter_project_id)   { user_profiles.sample.project_id }
      let(:answer_user_profile) { UserProfile.answer_user({'project_id' => filter_project_id }) }

      it 'condition{ project_id => $project_id }' do
        expect(answer_user_profile.project_id).to eq filter_project_id
      end
    end

    context '所属グループでフィルタする場合' do
      let(:filter_group_id)     { user_profiles.sample.group_id }
      let(:answer_user_profile) { UserProfile.answer_user({'group_id' => filter_group_id }) }

      it 'condition { group_id => $group_id }' do
        expect(answer_user_profile.group_id).to eq filter_group_id
      end
    end

    context 'filter by review_mdoe' do
      let(:user_profile)        { user_profiles.sample }
      let(:answer_user_profile) { UserProfile.answer_user({'review_mdoe' => 1 }, user_profile) }
      let(:answers)             { FactoryGirl.create_list :answer, 30, user_profile_id: user_profile.id }

      it 'condition { review_mdoe => 1 }' do
      end
    end
  end

  describe '#review_mode_user_profile_ids(user_profile)' do
    let!(:user_profiles)    { FactoryGirl.create_list :user_profile, 20, :with_user, :with_more_incorrect_answer }
    let!(:user_profile)     { user_profiles.sample }
    let!(:user_profile_ids) { user_profile.review_mode_user_profile_ids }

    it '得たIDすべてにおいて、不正解数が正解数以上になっている' do
      user_profile_ids.each do |id|
        correct_num = Answer.count(user_profile_id: user_profile.id, to_user_profile_id: id, correct: true)
        incorrect_num = Answer.count(user_profile_id: user_profile.id, to_user_profile_id: id, correct: false)
        expect(incorrect_num).to be >= correct_num
      end
    end
  end
end
