class ChangeUserIdColumnOnUserProfiles < ActiveRecord::Migration
  def change
    remove_column :user_profiles, :first_name
    remove_column :user_profiles, :last_name
    change_column_null :user_profiles, :user_id, false
  end
end
