class Group < ActiveRecord::Base
  has_many :user_profile

  validates :name, presence: true
end
