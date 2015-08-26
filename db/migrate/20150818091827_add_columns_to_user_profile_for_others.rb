class AddColumnsToUserProfileForOthers < ActiveRecord::Migration
  def change
    add_column :user_profiles, :gender, :string
    add_column :user_profiles, :joined_year, :integer
    add_column :user_profiles, :detail, :text
  end
end
