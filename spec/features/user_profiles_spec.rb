require 'rails_helper'

feature '登録者のプロフィール', type: :feature do
  include_context 'login_as_user'

  feature 'プロフィールの編集' do
    let!(:user) { FactoryGirl.create :user, :with_user_profile }
    let!(:user_profile) { user.user_profile }
    let!(:new_answer_name) { Forgery('name').name }

    scenario 'プロフィールを表示できる' do
      visit edit_user_profile_path(user_profile)

      expect(page).to have_field 'user_profile_answer_name', login_user.user_profile.answer_name
    end

    scenario 'プロフィールが編集できる' do
      visit edit_user_profile_path(user_profile)

      fill_in 'user_profile_answer_name', with: new_answer_name
      click_on I18n.t('helpers.submit.update')

      expect(current_path).to eq edit_user_profile_path(user_profile)

      expect(page).to have_content I18n.t('user_profiles.update.flash_edited')
      expect(page).to have_field 'user_profile_answer_name', new_answer_name

      expect(UserProfile.find(user_profile.id).answer_name).to eq new_answer_name
    end
  end
end
