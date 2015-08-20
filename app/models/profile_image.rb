class ProfileImage < ActiveRecord::Base
  belongs_to :user_profile
  validates :user_profile_id, presence: true, numericality: true
  validates :image, presence: true
  mount_uploader :image, ImageUploader
  validates :situation, presence: true
 end
