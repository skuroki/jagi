require 'rails_helper'

# cf http://easyramble.com/request-spec-for-devise-omniatuh.html
feature "Googleのアカウントを使いOmniauthでログインする" do
  service = :google_oauth2
  include_context 'setup_OmniAuth_config', service

  subject { page }

  background do
    visit user_omniauth_authorize_path(service)
  end

  scenario 'ログインできている' do
    expect(page.current_path).to eq root_path
    expect(page).to have_content oauth_user.info.name
    expect(page).to have_content oauth_user.provider
    expect(page).to have_content oauth_user.uid
    expect(page).to have_content oauth_user.email
  end
end
