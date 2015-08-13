FactoryGirl.define do
  factory :user_profile do
    answer_name     { Forgery(:basic).text }
  end
end
