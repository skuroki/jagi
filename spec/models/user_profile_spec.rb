require 'rails_helper'

RSpec.describe UserProfile, type: :model do
  it { should have_many(:profile_images) }
  it { should belong_to(:user) }
  it { should belong_to(:project) }

  it { should have_db_column(:answer_name).of_type(:string) }
  it { should validate_length_of(:answer_name).is_at_most(30) }

  it { should have_db_column(:group_id).of_type(:integer) }
  it { should validate_numericality_of(:group_id) }

  it { should have_db_column(:gender).of_type(:string) }

  it { should have_db_column(:joined_year).of_type(:integer) }
  it { should validate_numericality_of(:joined_year) }

  it { should have_db_column(:detail).of_type(:text) }
  it { should validate_length_of(:detail).is_at_most(10000) }
end
