require 'rails_helper'

describe LineItem do
  it 'has a valid factory' do
    expect(create(:carted_line_item)).to be_valid
    expect(create(:ordered_line_item)).to be_valid
  end
  
  describe 'methods' do
    describe 'total_price' do
      it 'gets the total price of one line_item' do
        create(:product, id: 1, title: 'test', price: 20)
        line_item = create(:carted_line_item, quantity: 2)
        expect(line_item.total_price).to eq(40)
      end
    end
  end
end