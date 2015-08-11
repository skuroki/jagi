FactoryGirl.define do
  factory :user do
    name      { Forgery(:basic).text }
    provider  { :google_oauth2 }
    uid       { Forgery(:basic).number }
    email     { Forgery(:email).address }
    token     { Forgery(:basic).encrypt }
    password  { Devise.friendly_token[0, 20] }
  end
end
