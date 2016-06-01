require 'rails_helper'

describe Cart do
#  let (:cart) { create(:cart, line_items: [create(:carted_line_item)]) }
#  subject { cart }
  
  it 'has a valid factory' do
    expect(create(:cart)).to be_valid
  end
  
#  it { is_expected.to have_many :line_items }
  describe 'methods' do
    describe 'add_product' do
      context 'when product does not exist in line_items' do
        it 'creates a new line item' do
          cart = create(:cart)
          expect do
            cart.add_product(1)
            cart.save
          end.to change(LineItem, :count).by(1)
        end
      end

      context 'when product exists in line_items' do
        it 'adds the quantity of the line_item' do
          cart = create(:cart, id: 1, line_items: [create(:carted_line_item)])
          expect do
            cart.add_product(1)
            cart.save
          end.to change(LineItem, :count).by(0)
        end
      end
    end

    describe 'decrement_product' do
      context 'when line_item quantity > 1' do
        it 'deducts the quantity of the line_item' do
          cart = create(:cart, id: 1, line_items: [create(:carted_line_item, quantity: 2)])
          expect do
            cart.line_items
            cart.decrement_product(1)
            cart.save
          end.to change(LineItem, :count).by(0)
        end
      end
      context 'when line_item quantity = 1' do
        it 'destroys the line_item' do
          cart = create(:cart, id: 1, line_items: [create(:carted_line_item)])
          expect do
            cart.line_items
            cart.decrement_product(1)
            cart.save
          end.to change(LineItem, :count).by(-1)
        end
      end
    end

    describe 'total_price' do
      it 'gets the total price of the whole cart' do
        create(:product, id: 1, price: 20)
        create(:product, id: 2, price: 30, category_id: 2, title: 'test2')
        cart = create(:cart, line_items: [create(:carted_line_item, quantity: 2)])
        cart.line_items << create(:carted_line_item, quantity: 2, product_id: 2) 
        expect(cart.total_price).to eq(100)
      end
    end
  end
end