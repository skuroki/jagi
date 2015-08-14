class UserProfile < ActiveRecord::Base
  belongs_to :user
  delegate :name, to: :user
  validates :user_id, presence: true, numericality: true, uniqueness: true
  validates :answer_name, length: { maximum: 30 }

  def answer_user
    self.class.all.sample
  end

  def total_correct
    Answer.where(correct: true, user_profile_id: self.id).count
  end

  def total_incorrect
    Answer.where(correct: false, user_profile_id: self.id).count
  end
end
