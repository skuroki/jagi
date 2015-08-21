require 'rails_helper'

feature "top page", type: :feature do
  feature 'トップページを表示' do
    background do
      visit root_path
    end

    context 'ログインしていない時' do
      scenario 'Googleへのログインリンクが表示される' do
        expect(page).to have_link I18n.t('pages.index.please_login_with_google'), user_omniauth_authorize_path(:google_oauth2)
      end
    end

    context 'ログインしている時' do
      include_context 'login_as_user'

      scenario '自分のユーザー情報が表示される' do
        expect(page).to have_content login_user.name
        expect(page).to have_content login_user.provider
        expect(page).to have_content login_user.uid
        expect(page).to have_content login_user.email
      end

      scenario 'クイズ開始リンクが表示される' do
        expect(page).to have_link 'クイズを始める', quiz_path
      end

      scenario 'プロフィール編集ページへの リンクが表示される' do
        expect(page).to have_link I18n.t('pages.index.edit_profile'), edit_user_profile_path(login_user.user_profile.id)
      end
    end
  end
end
