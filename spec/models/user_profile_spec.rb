require 'rails_helper'

RSpec.describe UserProfile, type: :model do
  it { should belong_to(:user) }
  it { should validate_length_of(:answer_name).is_at_most(30) }
end
