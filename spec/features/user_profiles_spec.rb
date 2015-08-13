require 'rails_helper'

feature '登録者のプロフィール', type: :feature do
  include_context 'login_as_user'

  feature 'プロフィールの編集' do
    let!(:user) { FactoryGirl.create :user, :with_user_profile }
    let!(:user_profile) { user.user_profile }
    let!(:new_last_name) { Forgery('name').last_name }
    let!(:new_first_name) { Forgery('name').first_name }
    let!(:new_answer_name) { Forgery('name').name }

    scenario 'プロフィールを表示できる' do
      visit edit_user_profile_path(user_profile)

      expect(page).to have_field 'user_profile_last_name', login_user.user_profile.last_name
      expect(page).to have_field 'user_profile_first_name', login_user.user_profile.first_name
      expect(page).to have_field 'user_profile_answer_name', login_user.user_profile.answer_name
    end

    scenario 'プロフィールが編集できる' do
      visit edit_user_profile_path(user_profile)

      fill_in 'user_profile_last_name', with: new_last_name
      fill_in 'user_profile_first_name', with: new_first_name
      fill_in 'user_profile_answer_name', with: new_answer_name
      click_on I18n.t('helpers.submit.update')

      expect(current_path).to eq edit_user_profile_path(user_profile)

      expect(page).to have_content I18n.t('user_profiles.update.flash_edited')
      expect(page).to have_field 'user_profile_last_name', new_last_name
      expect(page).to have_field 'user_profile_first_name', new_first_name
      expect(page).to have_field 'user_profile_answer_name', new_answer_name

      expect(UserProfile.find(user_profile.id).last_name).to eq new_last_name
      expect(UserProfile.find(user_profile.id).first_name).to eq new_first_name
      expect(UserProfile.find(user_profile.id).answer_name).to eq new_answer_name
    end
  end
end
