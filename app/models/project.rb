class Project < ActiveRecord::Base
  has_many :user_profile

  validates :name, presence: true
end
