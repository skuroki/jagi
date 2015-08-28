class Quiz
  def self.correct?(answer, user_profile)
    return false unless answer.present?
    user_profile.name == answer || user_profile.answer_name == answer
  end
end
