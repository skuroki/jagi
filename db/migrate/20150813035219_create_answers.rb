class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.references :user_profile
      t.integer :user_profile_id, null: false
      t.integer :to_user_profile_id, null: false
      t.boolean :correct, null: false
      t.string :answer, length: 30
    end
  end
end
