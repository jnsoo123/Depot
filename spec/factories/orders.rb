FactoryGirl.define do
  
  factory :order do
    name
    address 'test'
    email 'test@test.com'
    pay_type 'Check'
  end
  
  factory :invalid_order, parent: :order do
    name nil
    address nil
    email 'test'
  end
end