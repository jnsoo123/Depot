FactoryGirl.define do
  sequence(:name) { |n| "test#{n}" }
  
  factory :category do
    name
  end
  
  factory :invalid_category, parent: :category do
    name nil
  end
end