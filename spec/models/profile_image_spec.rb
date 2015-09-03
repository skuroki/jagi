require 'rails_helper'

RSpec.describe ProfileImage, type: :model do

  describe 'バリデーション' do
    it { should belong_to(:user_profile) }

    it { should have_db_column(:user_profile_id).of_type(:integer) }
    it { should validate_presence_of(:user_profile_id) }
    it { validate_numericality_of(:user_profile_id) }

    it { should have_db_column(:image).of_type(:string) }
    it { should validate_presence_of(:image) }

    it { should have_db_column(:situation).of_type(:string) }
    it { should validate_presence_of(:situation) }
  end

  describe 'ファイルアップロード' do
    let(:uploader) { ImageUploader.new(ProfileImage.new, :image) }

    before do
      ImageUploader.enable_processing = true
    end

    after do
      ImageUploader.enable_processing = false
      uploader.remove!
    end

    context '正常にアップロードできる' do
      subject! {
        File.open('fixtures/files/for_upload.jpg') do |f|
          uploader.store!(f)
        end
      }

      it "画像がリサイズされていること" do
        expect(uploader).to be_no_larger_than(300, 300)
      end

      it "画像ファイルのパーミッションが正しいこと" do
        expect(uploader).to have_permissions(0666)
      end
    end

    context 'アップロードできない' do
      it "不正な拡張子" do
        expect {
          File.open('fixtures/files/for_upload.txt') do |f|
            uploader.store!(f)
          end
        }.to raise_error(CarrierWave::IntegrityError)
      end
    end
  end

  describe 'Scopes' do
    describe '.with_situation' do
      let(:target_situation)          { Forgery(:basic).text }
      let(:target_profile_images)     { FactoryGirl.create_list :profile_image, 10, situation: target_situation }
      let(:untargeted_situation)      { Forgery(:basic).text }
      let(:untargeted_profile_images) { FactoryGirl.create_list :profile_image, 10, situation: untargeted_situation }

      subject { described_class.with_situation(target_situation) }

      it 'collects target_profile_images' do
        expect(subject).to match_array target_profile_images
      end
    end
  end
end
