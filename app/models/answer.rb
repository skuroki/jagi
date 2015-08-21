class Answer < ActiveRecord::Base
  belongs_to :user_profile
  validates :user_profile_id, presence: true, numericality: true
  validates :to_user_profile_id, presence: true, numericality: true
  validates :correct, inclusion: { in: [true, false, nil] }
  validates :answer, length: { maximum: 30 }
end
