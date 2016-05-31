FactoryGirl.define do
  factory :user do
    name "JN Soo"
    sequence(:email, 1000) { |n| "person#{n}@example.com" }
    username 'jnsoo'
    password "password"
    password_confirmation "password"
  end
end