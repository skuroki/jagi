FactoryGirl.define do
  factory :profile_image do
    image     { Rack::Test::UploadedFile.new(File.join(Rails.root, 'fixtures', 'files', 'for_upload.jpg')) }
    situation { ['normal', 'correct', 'incorrect'].sample }
  end
end
