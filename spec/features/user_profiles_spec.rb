require 'rails_helper'

feature '登録者のプロフィール', type: :feature do

  feature 'プロフィールの表示' do
    let!(:user_profile) { FactoryGirl.create :user_profile }

    background do
      visit user_profile_path(user_profile)
    end

    scenario 'プロフィールが表示されること' do
      expect(page).to have_content user_profile.last_name
      expect(page).to have_content user_profile.first_name
    end
  end

  feature 'プロフィールの編集' do
    let!(:user_profile) { FactoryGirl.create :user_profile }
    let!(:edited_first_name) { 'edited_first_name' }
    let!(:edited_last_name) { 'edited_last_name' }

    background do
      visit edit_user_profile_path(user_profile)
    end

    scenario 'プロフィールが編集できる' do
      fill_in 'user_profile_first_name', with: edited_first_name
      fill_in 'user_profile_last_name', with: edited_last_name
      click_on 'Update User profile'

      expect(current_path).to eq user_profile_path(user_profile)

      expect(page).to have_content edited_first_name
      expect(page).to have_content edited_last_name
      expect(page).to have_content I18n.t('user_profiles.update.flash_edited')
    end
  end

end
