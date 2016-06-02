require 'rails_helper'

describe Order do
  it 'has a valid factory' do
    expect(create(:order, line_items: [create(:ordered_line_item)])).to be_valid
  end
  
  describe 'validations' do
    it 'is invalid without a name' do
      expect(build(:order, name: nil, line_items: [create(:ordered_line_item)])).to_not be_valid
    end

    it 'is invalid without an address' do
      expect(build(:order, address: nil, line_items: [create(:ordered_line_item)])).to_not be_valid
    end
    
    it 'is invalid without/incorrect an email' do
      expect(build(:order, email: nil, line_items: [create(:ordered_line_item)])).to_not be_valid
      expect(build(:order, email: 'test', line_items: [create(:ordered_line_item)])).to_not be_valid
    end
    
    it 'is invalid without the correct payment type' do
      expect(build(:order, pay_type: 'Cash', line_items: [create(:ordered_line_item)])).to_not be_valid
      expect(build(:order, pay_type: nil, line_items: [create(:ordered_line_item)])).to_not be_valid
    end
    
    it 'is invalid without line_items' do
      expect(build(:order)).to_not be_valid
    end
  end
  
  describe 'methods' do
    context 'add_line_items_from_cart' do
      it 'transfers items from cart to line_items' do
        order = build(:order)
        cart = create(:cart, line_items: [create(:carted_line_item)])
        order.add_line_items_from_cart(cart)
        expect(order.line_items).to eq(cart.line_items)
      end
    end
    
    context 'total_price' do
      it 'gets the total price of whole order' do
        create(:product, id: 1, title: 'test', price: 20)
        create(:product, id: 2, title: 'test2', price: 30, category_id: 2)
        order = create(:order, line_items: [create(:ordered_line_item, quantity: 2, product_id: 1)])
        order.line_items << create(:ordered_line_item, quantity: 2, product_id: 2)
        expect(order.total_price).to eq(100)
      end
    end
  end
end