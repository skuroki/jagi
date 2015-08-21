FactoryGirl.define do
  factory :answer do
    user_profile_id    { Forgery(:basic).number }
    to_user_profile_id { [*1..3].sample }
    answer             { Forgery(:basic).text }
    correct            { Forgery(:basic).boolean }
  end
end
