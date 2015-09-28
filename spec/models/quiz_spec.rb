require 'rails_helper'

RSpec.describe Quiz, type: :model do
  describe '.correct?' do
    let(:user_profiles) { FactoryGirl.create_list :user_profile, 5 }
    let(:answer_user_profile) { user_profiles.sample }

    it 'answer name is matched' do
      expect(Quiz.correct?(answer_user_profile, answer_user_profile.user.name)).to be true
    end

    it 'Google full name is matched' do
      expect(Quiz.correct?(answer_user_profile, answer_user_profile.answer_name)).to be true
    end

    it 'last name is matched (loosely judge by regular expression)' do
      expect(Quiz.correct?(answer_user_profile, answer_user_profile.user.name[0..1])).to be true
    end

    it 'first name is matched (loosely judge by regular expression)' do
      expect(Quiz.correct?(answer_user_profile, answer_user_profile.user.name[-2..-1])).to be true
    end
  end
end
