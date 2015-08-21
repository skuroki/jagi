FactoryGirl.define do
  factory :user_profile do
    answer_name     { Forgery(:basic).text }
    group_id        { [*1..3].sample }
    project_id      { [*1..3].sample }
    joined_year     { [Time.zone.now.year, Time.zone.now.year-1].sample }
    gender          { ['male', 'female'].sample }

    trait :with_user do
      user { FactoryGirl.create :user }
    end

    trait :with_group do
      after(:create) do |user_profile|
        begin
          FactoryGirl.create :group, id: user_profile.group_id
        rescue
        end
      end
    end

    trait :with_project do
      after(:create) do |user_profile|
        begin
          FactoryGirl.create :project, id: user_profile.project_id
        rescue
        end
      end
    end

    trait :with_answer do
      after(:create) do |user_profile|
        FactoryGirl.create_list :answer, 10, user_profile_id: user_profile.id, to_user_profile_id: UserProfile.all.sample.id
      end
    end

    trait :with_more_incorrect_answer do
      after(:create) do |user_profile|
        FactoryGirl.create_list :answer, 6, user_profile_id: user_profile.id, to_user_profile_id: UserProfile.all.sample.id, correct: false
        FactoryGirl.create_list :answer, 4, user_profile_id: user_profile.id, to_user_profile_id: UserProfile.all.sample.id, correct: true
      end
    end
  end
end
