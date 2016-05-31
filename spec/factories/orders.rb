FactoryGirl.define do
  factory :order do
    name 'test'
    address 'test'
    email 'test@test.com'
    pay_type 'Check'
    
    before(:create) do |order|
      create(:carted_line_item, order_id: order.id, cart_id: nil )  
    end
  end
end