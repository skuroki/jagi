class QuizzesController < ApplicationController
  def show
    @user_profile = UserProfile.all.sample
  end

  def answer
    @user_profile = UserProfile.find(params[:answer_user_id])

    if @user_profile.answer_name.eql? params[:answer_user_name]
      flash[:notice] = '正解'
    else
      flash[:notice] = "不正解! 答えは#{@user_profile.answer_name.to_s}です。"
    end
    redirect_to quiz_path
  end
end
