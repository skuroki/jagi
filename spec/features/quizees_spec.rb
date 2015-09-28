require 'rails_helper'

feature 'クイズ', type: :feature do
  include_context 'login_as_user'

  feature 'クイズを始める' do
    before do
      visit new_quiz_path
    end

    scenario 'クイズ開始フォームが表示される' do
      expect(page).to have_select('joined_year')
      expect(page).to have_select('project_id')
      expect(page).to have_select('group_id')
      # expect(page).to have_field('review_mode')
      expect(page).to have_button I18n.t('pages.index.start_quiz')
    end

    context 'クイズを始めるボタンをクリックしたとき' do
      scenario 'クイズが開始される' do
        click_button I18n.t('pages.index.start_quiz')
        expect(current_path).to eq question_quiz_path
      end
    end
  end

  # FIXME: ビューのテストにしかなってないのでなおす
  feature 'クイズを進める' do
    let!(:users) { FactoryGirl.create_list :user_profile, 5 }
    let!(:question_user) { FactoryGirl.create :user_profile }

    before do
      visit new_quiz_path
      click_button I18n.t('pages.index.start_quiz')
    end

    scenario '回答入力フォームが表示される' do
      expect(page).to have_field('answer_name')
      expect(page).to have_button I18n.t('quiz.question.submit')
    end

    feature 'クイズに回答する' do
      before do
        allow_any_instance_of(Quiz).to receive(:last_question).and_return(question_user)
      end

      scenario '問題となったユーザのプロフィールが表示される' do
        fill_in 'answer_name', with: question_user.answer_name
        click_button I18n.t('quiz.question.submit')

        expect(page).to have_content question_user.user.name
        expect(page).to have_content question_user.answer_name
        # expect(page).to have_content gender
        # expect(page).to have_content joined_year
        # expect(page).to have_content group_name
        # expect(page).to have_content project_name
        expect(page).to have_content question_user.detail
      end

      context '正解だった場合' do
        before do
          allow_any_instance_of(Quiz).to receive(:last_result).and_return(:win)
        end

        scenario 'お祝いのメッセージが表示される' do
          fill_in 'answer_name', with: question_user.answer_name
          click_button I18n.t('quiz.question.submit')

          expect(page).to have_content I18n.t('quiz.result.correct')
        end

        scenario '正解数の合計が表示される' do
          fill_in 'answer_name', with: question_user.answer_name
          click_button I18n.t('quiz.question.submit')

          click_button I18n.t('quiz.result.next')
          expect(page).to have_css('#total_correct', I18n.t('quiz.show.correct'))
          expect(page).to have_css('#total_correct', text: '1')
        end
      end

      context '不正解だった場合' do
        before do
          allow_any_instance_of(Quiz).to receive(:last_result).and_return(:lose)
        end

        scenario 'お悔やみのメッセージが表示される' do
          fill_in 'answer_name', with: question_user.answer_name
          click_button I18n.t('quiz.question.submit')

          expect(page).to have_content I18n.t('quiz.result.incorrect')
        end

        scenario '不正解数の合計が表示される' do
          fill_in 'answer_name', with: question_user.answer_name
          click_button I18n.t('quiz.question.submit')

          click_button I18n.t('quiz.result.next')
          expect(page).to have_css('#total_incorrect', I18n.t('quiz.show.incorrect'))
          expect(page).to have_css('#total_incorrect', text: '1')
        end
      end
    end
  end
end
