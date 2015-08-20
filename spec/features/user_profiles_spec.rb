require 'rails_helper'

feature '登録者のプロフィール', type: :feature do
  include_context 'login_as_user'

  feature 'プロフィールの編集' do
    let!(:user) { FactoryGirl.create :user, :with_user_profile }
    let!(:user_profile) { user.user_profile }
    let!(:new_answer_name) { Forgery(:name).full_name }

    scenario 'プロフィールを表示できる' do
      visit edit_user_profile_path(user_profile)

      expect(page).to have_field 'user_profile_answer_name', login_user.user_profile.answer_name
    end

    feature 'プロフィールが編集できる' do
      background do
        visit edit_user_profile_path(user_profile)
      end

      scenario 'プロフィールが編集できる' do
        fill_in 'user_profile_answer_name', with: new_answer_name
        click_on I18n.t('helpers.submit.update')

        expect(current_path).to eq edit_user_profile_path(user_profile)
        expect(page).to have_content I18n.t('user_profiles.update.flash_edited')
        expect(page).to have_field 'user_profile_answer_name', new_answer_name
        expect(UserProfile.find(user_profile.id).answer_name).to eq new_answer_name
      end

      context '画像が添付された場合' do
        after do
          ProfileImage.situations.each do |situation|
            profile_image = ProfileImage.find_by(user_profile_id: user_profile.id, situation: situation)
            profile_image.remove_image!
            profile_image.save
          end
        end

        scenario '画像がアップロード・リサイズできる' do
          ProfileImage.situations.each do |situation|
            attach_file "profile_image_#{situation}_image", "fixtures/files/for_upload.jpg"
          end

          click_on I18n.t('helpers.submit.update')

          ProfileImage.situations.each do |situation|
            profile_image = ProfileImage.find_by(user_profile_id: user_profile.id, situation: situation)

            expect(profile_image).to be_truthy
            expect(page).to have_css("img[src='#{profile_image.image.url}']")

            file_exists = File.exists? ("public#{profile_image.image.url}")
            expect(file_exists).to be_truthy
          end
        end
      end
    end
  end
end
