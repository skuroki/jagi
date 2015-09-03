FactoryGirl.define do
  factory :profile_image do
    user_profile { FactoryGirl.create :user_profile }

    image     { Rack::Test::UploadedFile.new(File.join(Rails.root, 'fixtures', 'files', 'for_upload.jpg')) }
    situation { 'normal' }

    trait :with_correct_image do
      situation { 'correct' }
    end

    trait :with_incorrect_image do
      situation { 'incorrect' }
    end
  end
end
