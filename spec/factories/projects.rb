FactoryGirl.define do
  factory :project do
    name      { Forgery(:basic).text }
  end
end

