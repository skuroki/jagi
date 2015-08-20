class CreateProfileImages < ActiveRecord::Migration
  def change
    create_table :profile_images do |t|
      t.references :user_profile
      t.integer :user_profile_id, null: false
      t.string :image, null: false
      t.string :situation, null: false

      t.timestamps null: false
    end
  end
end
