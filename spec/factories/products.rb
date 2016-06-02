FactoryGirl.define do
  factory :product do |p|
    sequence(:title) { |n| "title#{n}" }
    description 'test'
    image_url 'test.jpg'
    price 12.50
    category_id { create(:category).id }
    
#    before(:create) do |product| 
#      create(:category, id: product.category_id )
#    end
  end
  
  factory :invalid_product, parent: :product do
    title nil
  end
  
end