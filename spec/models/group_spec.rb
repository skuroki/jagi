require 'rails_helper'

RSpec.describe Group, type: :model do
  it { should have_many(:user_profile) }

  it { should have_db_column(:name).of_type(:string) }
  it { should validate_presence_of(:name) }
 end
