class PageController < ApplicationController
  def index
    @projects = Project.all
    @groups = Group.all
  end
end
