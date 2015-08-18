FactoryGirl.define do
  factory :group do
    name      { Forgery(:basic).text }
  end
end

