FactoryGirl.define do
  factory :user_profile do
    answer_name     { Forgery('name').name }
  end
end
