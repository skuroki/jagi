class UserProfile < ActiveRecord::Base
  belongs_to :user
  has_many :profile_images
  belongs_to :project
  belongs_to :group

  delegate :name, to: :user

  validates :user_id, presence: true, numericality: true, uniqueness: true
  validates :answer_name, allow_nil: true, length: { maximum: 30 }
  validates :group_id, allow_nil: true, numericality: true
  validates :project_id, allow_nil: true, numericality: true
  validates :gender, allow_nil: true, inclusion: { in: ['', 'male', 'female'] }
  validates :joined_year, allow_nil: true, numericality: true
  validates :detail, allow_nil: true, length: { maximum: 10000 }

  def self.for_filter_params
    [:joined_year, :group_id, :project_id]
  end

  def self.answer_user(filter = {}, user_profile = {})
    conditions = {}
    not_where = {}

    conditions[:project_id]     =  filter['project_id'] if filter['project_id'].present?
    conditions[:group_id]       =  filter['group_id'] if filter['group_id'].present?
    conditions[:joined_year]    =  filter['joined_year'] if filter['joined_year'].present?
    conditions[:id]             =  user_profile.review_mode_user_profile_ids if filter['review_mode'].present? && user_profile.present?
    conditions[:profile_images] =  { situation: 'normal' }

    not_where[:answer_name]     =  nil
    not_where[:id]              =  user_profile.id if user_profile.present? # 自分は出題しない
    not_where[:profile_images]  =  { situation: nil }

    UserProfile.joins(:profile_images).where(conditions).where.not(not_where).sample
  end

  def review_mode_user_profile_ids
    # ActiveRecordでの書き方がわからない
    sql_query = 'SELECT `answers`.*, SUM(correct=1) AS count_correct, SUM(correct=0) AS count_incorrect FROM answers WHERE user_profile_id = ? GROUP BY to_user_profile_id HAVING count_incorrect >= count_correct AND count_incorrect >= 1'

    distincted_answers = Answer.find_by_sql([sql_query, self.id])
    distincted_answers.map(&:to_user_profile_id)
  end

  def answer_correct?(answer)
    return false unless answer.present?
    return true if answer == self.name
    return true if answer == self.answer_name
  end

  def total_correct
    Answer.where(correct: true, user_profile_id: self.id).count
  end

  def total_incorrect
    Answer.where(correct: false, user_profile_id: self.id).count
  end

  def find_image(situation)
    profile_image = ProfileImage.find_by(user_profile_id: self.id, situation: situation)
    profile_image.try(:image)
  end

  def find_image_url(situation)
    image = find_image(situation)
    image.try(:url)
  end
end

