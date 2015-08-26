class AddReferencesToUserProfile < ActiveRecord::Migration
  def change
    add_reference :user_profiles, :project, index: true
    add_reference :user_profiles, :group, index: true
  end
end
