class Quiz
  require 'nkf'

  attr_accessor :total, :correct, :incorrect

  def initialize(params)
    @user_id    = params[:user_id]
    @conditions = params[:conditions]
    @questions  = params[:questions] || questions
    @answers    = params[:answers] || []
    @total      = params[:total] || 0
    @correct    = params[:correct] || 0
    @incorrect  = params[:incorrect] || 0
  end

  def next_question
    UserProfile.find_by(user_id: @questions[@answers.count])
  end

  def last_question
    UserProfile.find_by(user_id: @questions[@answers.count - 1])
  end

  def last_result
    self.class.correct?(last_question, @answers.last)? :win : :lose
  end

  def fin?
    @questions.count == @questions.answers.count
  end

  def answer!(answer_name)
    @answers << answer_name
    increment_result
  end

  private

  def increment_result
    if last_result == :win
      @correct   += 1
    else
      @incorrect += 1
    end
    @total += 1
  end

  def questions
    UserProfile.
      without_user(@user_id).
      with_image.
      with_group(@conditions[:group_id]).
      with_project(@conditions[:project_id]).
      with_gender(@conditions[:gender]).
      with_joined_year(@conditions[:joined_year]).
      pluck(:user_id).
      shuffle
  end

  def self.correct?(user_profile, answer_text)
    # ユーザーが決めた正解文字列での判定 (ひらがな入力でもカタカナ入力でも等しく判定する)
    if NKF.nkf("--hiragana -w", user_profile.answer_name) == NKF.nkf("--hiragana -w", answer_text)
      return true
    # Google認証情報の氏名使って判定 (完全一致)
    elsif user_profile.user.name == answer_text
      return true
    # Google認証情報の氏名使って、苗字をゆるく判定 (最初の二文字が一致すれば正解)
    elsif answer_text.match("^#{user_profile.user.name[0..1]}")
      return true
    # Google認証情報の氏名を使って、名前をゆるく判定 (ラストの二文字が一致すれば正解)
    elsif answer_text.match("#{user_profile.user.name[-2..-1]}$")
      return true
    end
    false
  end
end
