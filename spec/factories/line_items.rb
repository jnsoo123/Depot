FactoryGirl.define do
  factory :line_item do
    product_id 1
    quantity 1
  end
  
  factory :ordered_line_item, parent: :line_item do
    cart_id nil
    order_id 1
  end
  
  factory :carted_line_item, parent: :line_item do
    cart_id 1
    order_id nil
  end
end