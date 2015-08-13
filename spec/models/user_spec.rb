require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_one(:user_profile) }

  describe '.find_for_google_oauth2(auth)' do
    include_context 'setup_OmniAuth_config', :google_oauth2
    subject { described_class.find_for_google_oauth2(oauth_user) }

    context 'when user exists' do
      let!(:user) { FactoryGirl.create :user, email: oauth_user.info.email, uid: oauth_user.uid }
      it { expect(subject.uid).to eq oauth_user.uid.to_s }
      it { expect(subject.email).to eq oauth_user.info.email }
      it 'create no user' do
        expect { subject }.to change{ User.count }.by(0)
      end
    end

    context 'when user not exists' do
      it { expect(subject.uid).to eq oauth_user.uid.to_s }
      it { expect(subject.email).to eq oauth_user.info.email }
      it { expect(subject.user_profile.first_name).to eq oauth_user.name }

      it 'create user' do
        expect { subject }.to change{ UserProfile.count }.by(1).and change{ User.count }.by(1)
      end
    end
 end
end
