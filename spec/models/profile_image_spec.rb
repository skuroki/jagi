require 'rails_helper'

RSpec.describe ProfileImage, type: :model do
  it { should belong_to(:user_profile) }

  it { should have_db_column(:user_profile_id).of_type(:integer) }
  it { should validate_presence_of(:user_profile_id) }
  it { validate_numericality_of(:user_profile_id) }

  it { should have_db_column(:image).of_type(:string) }
  it { should validate_presence_of(:image) }

  it { should have_db_column(:situation).of_type(:string) }
  it { should validate_presence_of(:situation) }
end
