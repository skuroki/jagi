class PageController < ApplicationController
  def index
    @start_button_enabled = UserProfile.new.answer_user.present?
  end
end
