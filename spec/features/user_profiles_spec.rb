require 'rails_helper'

feature '登録者のプロフィール', type: :feature do
  include_context 'login_as_user'

  feature 'プロフィールの編集' do
    let!(:user) { FactoryGirl.create :user, :with_user_profile }
    let!(:user_profile) { user.user_profile }
    let!(:projects) { FactoryGirl.create_list :project, 5 }
    let!(:groups) { FactoryGirl.create_list :group, 5 }

    let!(:new_answer_name) { Forgery(:name).full_name }
    let!(:new_joined_year) { "#{Time.zone.now.year}#{I18n.t('user_profiles.edit.year')}" }
    let!(:new_project) { projects.sample.name }
    let!(:new_group) { groups.sample.name }
    let!(:new_gender) { I18n.t('user_profiles.edit.male') }
    let!(:new_detail) { Forgery(:basic).text }

    let!(:edited_message) { I18n.t('user_profiles.update.flash_edited') }
    let!(:update_button) { I18n.t('helpers.submit.update') }

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
        select new_gender, from: 'user_profile_gender'
        select new_joined_year, from: 'user_profile_joined_year'
        select new_group, from: 'user_profile_group_id'
        select new_project, from: 'user_profile_project_id'
        fill_in 'user_profile_detail', with: new_detail

        click_on update_button

        expect(current_path).to eq edit_user_profile_path(user_profile)

        expect(page).to have_field 'user_profile_answer_name', new_answer_name
        expect(page).to have_select('user_profile_joined_year', selected: new_joined_year)
        expect(page).to have_select('user_profile_gender', selected: new_gender)
        expect(page).to have_select('user_profile_project_id', selected: new_project )
        expect(page).to have_select('user_profile_group_id', selected: new_group )
        expect(page).to have_field 'user_profile_detail', new_detail
        expect(page).to have_content edited_message

        expect(UserProfile.find(user_profile.id).answer_name).to eq new_answer_name
        expect(UserProfile.find(user_profile.id).detail).to eq new_detail
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
