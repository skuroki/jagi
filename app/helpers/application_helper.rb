module ApplicationHelper
  def joined_years_selection
    (1990..Time.zone.now.year+1).map { |year|
      ["#{year}#{I18n.t('user_profiles.edit.year')}", year]
    }.reverse
  end

  def groups
    Group.order('name ASC')
  end

  def projects
    Project.order('name ASC')
  end
end
