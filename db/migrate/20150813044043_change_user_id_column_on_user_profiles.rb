class ChangeUserIdColumnOnUserProfiles < ActiveRecord::Migration
  def change
    change_column_null :user_profiles, :user_id, false
    remove_column :user_profiles, :first_name
    remove_column :user_profiles, :last_name
  end
end
