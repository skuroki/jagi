class AddAnswerNameToUserProfile < ActiveRecord::Migration
  def change
    add_column :user_profiles , :answer_name, :string
  end
end
