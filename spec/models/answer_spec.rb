require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:user_profile) }

  it { should have_db_column(:user_profile_id).of_type(:integer) }
  it { should validate_presence_of(:user_profile_id) }
  it { validate_numericality_of(:user_profile_id) }

  it { should have_db_column(:to_user_profile_id).of_type(:integer) }
  it { should validate_presence_of(:to_user_profile_id) }
  it { validate_numericality_of(:to_user_profile_id) }

  it { should have_db_column(:answer).of_type(:string) }
  it { should validate_length_of(:answer).is_at_most(30) }

  it { should have_db_column(:correct).of_type(:boolean) }
end
