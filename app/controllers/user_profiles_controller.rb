class UserProfilesController < ApplicationController
  before_action :require_logged_in, :set_situations

  def edit
    @user_profile = UserProfile.find(params[:id])
    @projects = Project.all
    @groups = Group.all

    @joined_years = []
    for year in 2000..Time.zone.now.year do
      @joined_years.unshift ["#{year}#{I18n.t('user_profiles.edit.year')}", year]
    end
  end

  def update
    @user_profile = UserProfile.find(params[:id])

    result = @user_profile.update(user_profile_params)

    @situations.each do |situation|
      permitted = profile_image_params("profile_image_#{situation}".to_sym)
      ProfileImage.save_image permitted
    end

    if result
      flash[:notice] = I18n.t('user_profiles.update.flash_edited')
      redirect_to edit_user_profile_path(@user_profile)
    else
      render :edit
    end
  end

  private

  def user_profile_params
    params.require(:user_profile).permit(:answer_name, :gender, :group_id, :project_id, :joined_year, :detail)
  end

  def profile_image_params (target)
    params.require(target).permit(:user_profile_id, :image, :situation)
  end

  def require_logged_in
    redirect_to root_path unless current_user
  end

  def set_situations
    @situations = ProfileImage.situations
  end
end
