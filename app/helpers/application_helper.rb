module ApplicationHelper
  def groups
    Group.order('name ASC')
  end

  def projects
    Project.order('name ASC')
  end
end
