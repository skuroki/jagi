
class QuizzesController < ApplicationController
  def show
    @answer_user_profile = UserProfile.answer_user(params, current_user.user_profile)

    @total_correct = current_user.user_profile.total_correct
    @total_incorrect = current_user.user_profile.total_incorrect

    @start_button_enabled = @answer_user_profile.present?
    @projects = Project.all
    @groups = Group.all
    @profile_image_normal = ProfileImage.find_by(situation: :normal, user_profile_id: @answer_user_profile.id) if @answer_user_profile
  end

  def answer
    @answer_user_profile = UserProfile.find(params[:answer_user_id])

    if @answer_user_profile.answer_name == params[:answer_user_name]
      case_correct
    else
      case_incorrect
    end
    redirect_to quiz_path(params.permit(UserProfile.for_filter_params))
  end

  private

  def case_correct
    create_answer_history(true, params[:answer_user_name], current_user.user_profile.id, params[:answer_user_id])
    flash[:notice] = I18n.t("quiz.show.correct_result")
  end

  def case_incorrect
    create_answer_history(false, params[:answer_user_name], current_user.user_profile.id, params[:answer_user_id])
    flash[:notice] = I18n.t("quiz.show.incorrect_result", answer_name: @answer_user_profile.answer_name)
  end

  def create_answer_history(correct, answer, user_profile_id, to_user_profile_id)
    Answer.create!(correct: correct, answer: answer, user_profile_id: user_profile_id, to_user_profile_id: to_user_profile_id)
  end
end
