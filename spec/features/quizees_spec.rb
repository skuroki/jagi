require 'rails_helper'

feature "quiz page", type: :feature do
  feature '出題ページを表示' do
    include_context 'login_as_user'

    let(:user_profiles) { FactoryGirl.create_list :user_profile, 30, :with_user, :with_group, :with_project, :with_normal_profile_image }

    context '基本項目でフィルタする場合' do
      let(:filter_user_profile) { user_profiles.sample }
      let(:joined_year_filter)  { filter_user_profile.joined_year }
      let(:group_id_filter)     { filter_user_profile.group_id }
      let(:project_id_filter)   { filter_user_profile.project_id }
      let(:filters)             { { 'joined_year' => joined_year_filter, 'group_id' => group_id_filter, 'project_id' => project_id_filter } }

      let(:answer_user_profile) { UserProfile.answer_user(filters, login_user.user_profile) }

      background do
        allow(UserProfile).to receive_message_chain(:answer_user).and_return(answer_user_profile)

        visit quiz_path(filters)
      end

      scenario 'クイズの問題と解答欄が表示される' do
        expect(page).to have_selector('#user_image')
        expect(page).to have_field('answer_user_name')
        expect(find("#answer_user_id", visible: false).value.to_i).to eq answer_user_profile.id
      end

      feature '回答する' do
        context '正解の場合' do
          background do
            fill_in 'answer_user_name', with: answer_user_profile.answer_name
            click_on 'answer'
          end

          scenario '回答したら結果が表示される' do
            expect(page).not_to have_css('div.notice', text: I18n.t('quiz.show.incorrect'))
          end

          scenario '回答履歴に正解が記録される' do
            expect(page).to have_css('#total_correct', I18n.t('quiz.show.correct'))
            expect(page).to have_css('#total_correct', text: '1')

            expect(login_user.user_profile.total_correct).to eq 1
          end
        end

        context '不正解の場合' do
          let(:answer_name) { Forgery(:basic).text }

          background do
            visit quiz_path

            fill_in 'answer_user_name', with: answer_name
            click_on 'answer'
          end

          scenario '回答したら結果が表示される' do
            expect(page).to have_css('div.notice', text: I18n.t('quiz.show.incorrect_result', answer_name: answer_user_profile.answer_name))
          end

          scenario '回答履歴に不正解が記録される' do
            expect(page).to have_css('#total_incorrect', I18n.t('quiz.show.incorrect'))
            expect(page).to have_css('#total_incorrect', text: '1')

            expect(login_user.user_profile.total_incorrect).to eq 1
          end
        end
      end
    end

    context '復習モードでフィルタする場合' do
      let!(:user_profile)        { user_profiles.sample }
      let!(:filters)             { { 'review_mode' => 1 } }
      let!(:answers)             { FactoryGirl.create_list :answer, 30, user_profile_id: user_profile.id, correct: false }
      let!(:answer_user_profile) { UserProfile.answer_user(filters, user_profile) }

      background do
        allow(UserProfile).to receive_message_chain(:answer_user).and_return(answer_user_profile)
      end

      # TODO: 未完成
      # context '出題できるものがある場合' do
      #   scenario '出題のフィルタリングが出来ている' do
      #     visit quiz_path(filters)
      #     expect(find("#answer_user_id", visible: false).value.to_i).to eq answer_user_profile.id
      #   end
      # end
    end
  end
end
