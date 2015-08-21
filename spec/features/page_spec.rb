require 'rails_helper'

feature "top page", type: :feature do
  feature 'トップページを表示' do
    let!(:projects)          { FactoryGirl.create_list :project, 2 }
    let!(:groups)            { FactoryGirl.create_list :group, 2 }
    let!(:users)             { FactoryGirl.create_list :user, 10, :with_user_profile }

    let(:joined_year_filter) { Time.zone.now.year }
    let(:project_filter)     { projects.sample.name }
    let(:group_filter)       { groups.sample.name }

    context 'ログインしていない時' do
      scenario 'Googleへのログインリンクが表示される' do
        visit root_path

        expect(page).to have_link I18n.t('pages.index.please_login_with_google'), user_omniauth_authorize_path(:google_oauth2)
      end
    end

    context 'ログインしている時' do
      include_context 'login_as_user'

      background do
        visit root_path
      end

      scenario '自分のユーザー情報が表示される' do
        expect(page).to have_content login_user.name
        expect(page).to have_content login_user.provider
        expect(page).to have_content login_user.uid
        expect(page).to have_content login_user.email
      end

      scenario 'クイズ開始フォームが表示される' do
        expect(page).to have_select('joined_year')
        expect(page).to have_select('project_id')
        expect(page).to have_select('group_id')
        expect(page).to have_button I18n.t('pages.index.start_quiz')

        select joined_year_filter, from: 'joined_year'
        select project_filter, from: 'project_id'
        select group_filter, from: 'group_id'
      end

      scenario 'クイズ開始ボタンを押すと出題ページに移動する' do
        click_on I18n.t('pages.index.start_quiz')
        expect(current_path).to eq quiz_path
      end
    end
  end
end
