require 'rails_helper'

feature 'Quiz', type: :feature do
  include_context 'login_as_user'

  feature 'Start' do
    before do
      visit new_quiz_path
    end

    scenario 'display starting form' do
      expect(page).to have_select('joined_year')
      expect(page).to have_select('project_id')
      expect(page).to have_select('group_id')
      expect(page).to have_button I18n.t('quiz.new.start_quiz')
    end

    context 'When the user clicks start button' do
      scenario 'the quiz starts' do
        click_button I18n.t('quiz.new.start_quiz')
        expect(current_path).to eq question_quiz_path
      end
    end
  end

  # FIXME: ビューのテストにしかなってないのでなおす
  feature 'Answer' do
    let!(:users) { FactoryGirl.create_list :user_profile, 30 }
    let!(:question_user) { FactoryGirl.create :user_profile }

    before do
      visit new_quiz_path
      click_button I18n.t('quiz.new.start_quiz')
    end

    feature 'To one question' do
      scenario 'display answer form' do
        expect(page).to have_field('answer_name')
        expect(page).to have_button I18n.t('quiz.question.submit')
      end

      feature 'User challenges to a game and get result' do
        before do
          allow_any_instance_of(Quiz).to receive(:last_question).and_return(question_user)
        end

        scenario 'display question user profile' do
          fill_in 'answer_name', with: question_user.answer_name
          click_button I18n.t('quiz.question.submit')

          expect(page).to have_content question_user.user.name
          expect(page).to have_content question_user.answer_name
          expect(page).to have_content question_user.detail
          # expect(page).to have_content gender
          # expect(page).to have_content joined_year
          # expect(page).to have_content group_name
          # expect(page).to have_content project_name
        end

        context 'When the answer was correct' do
          before do
            allow_any_instance_of(Quiz).to receive(:last_result).and_return(:win)
          end

          scenario 'display winning message' do
            fill_in 'answer_name', with: question_user.answer_name
            click_button I18n.t('quiz.question.submit')

            expect(page).to have_content I18n.t('quiz.result.correct')
          end

          scenario 'display total correct num' do
            fill_in 'answer_name', with: question_user.answer_name
            click_button I18n.t('quiz.question.submit')

            click_button I18n.t('quiz.result.next')
            expect(page).to have_css('#total_correct', I18n.t('quiz.show.correct'))
            expect(page).to have_css('#total_correct', text: '1')
          end
        end

        context 'When the answer was incorrect' do
          before do
            allow_any_instance_of(Quiz).to receive(:last_result).and_return(:lose)
          end

          scenario 'display losing message' do
            fill_in 'answer_name', with: question_user.answer_name
            click_button I18n.t('quiz.question.submit')

            expect(page).to have_content I18n.t('quiz.result.incorrect')
          end

          scenario 'display total incorrect num' do
            fill_in 'answer_name', with: question_user.answer_name
            click_button I18n.t('quiz.question.submit')

            click_button I18n.t('quiz.result.next')
            expect(page).to have_css('#total_incorrect', I18n.t('quiz.show.incorrect'))
            expect(page).to have_css('#total_incorrect', text: '1')
          end
        end
      end
    end

    feature 'To many questions continuity' do
      let(:question_user_ids) {
        questions = []

        10.times do
          questions.push find('#question_image')['data-user-id'].to_i

          fill_in 'answer_name', with: question_user.answer_name
          click_button I18n.t('quiz.question.submit')
          click_button I18n.t('quiz.result.next')
        end
        questions
      }

      scenario 'all questions are shuffled' do
        expect(question_user_ids).not_to eq question_user_ids.sort
      end

      scenario 'all questions have each different users' do
        expect(question_user_ids.uniq.size).to eq question_user_ids.size
      end
    end
  end
end
