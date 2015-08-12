class UserProfile < ActiveRecord::Base
  belongs_to :user
  delegate :name, to: :user
  validates :user_id, presence: true, numericality: true, uniqueness: true
  validates :answer_name, length: { maximum: 30 }
end
