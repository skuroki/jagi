require 'rails_helper'

feature "quiz page", type: :feature do
  feature '出題ページを表示' do
    include_context 'login_as_user'
    let!(:target_users) { FactoryGirl.create_list :user, 10, :with_user_profile }
    let!(:target_user_profile) { target_users.sample.user_profile }

    background do
      allow_any_instance_of(Array).to receive(:sample).and_return(target_user_profile)
    end

    scenario 'クイズの問題と解答欄が表示される' do
      visit quiz_path
      expect(page).to have_selector('#user_image')
      expect(page).to have_field('answer_user_name')
      expect(find("#answer_user_id", visible: false).value.to_i).to eq target_user_profile.id
    end

    feature '回答する' do
      context '正解の場合' do
        scenario '回答したら結果が表示される' do
          visit quiz_path

          fill_in 'answer_user_name', with: target_user_profile.answer_name
          click_on 'answer'

          expect(page).not_to have_content('不正解')
        end
      end

      context '不正解の場合' do
        let(:answer_name) { Forgery(:basic).text }

        scenario '回答したら結果が表示される' do
          visit quiz_path

          fill_in 'answer_user_name', with: answer_name
          click_on 'answer'

          expect(page).to have_content('不正解')
        end
      end
    end
  end
end
