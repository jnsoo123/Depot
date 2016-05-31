require 'rails_helper'

describe LineItemsController, type: :controller do
  describe 'POST #create' do
    context 'when cart is empty' do
      it 'creates the line_item' do
        expect { post :create, { product_id: create(:product), type: 'add' } }.to change(LineItem, :count).by(1)  
      end
    end
    
    context 'when cart is not empty' do
      context 'when adding a product' do
        context 'when product is same' do
          it 'does not create a new line_item' do
            create(:carted_line_item, product_id: 1)
            create(:product, id: 1)
            expect { post :create, { product_id: 1, type: 'add' } }.to change(LineItem, :count).by(0) 
          end
          
          it 'increments the current line_items\' quantity' do
            create(:carted_line_item, product_id: 1)
            create(:product, id: 1)
            expect { post :create, { product_id: 1, type: 'add' } }.to change{ LineItem.last.quantity }.by(1) 
          end
        end

        context 'when product is not same' do
          it 'creates a new line_item' do
            expect { post :create, { product_id: create(:product).id, type: 'add' } }.to change(LineItem, :count).by(1) 
          end
        end
      end
      
      context 'when deducting a product' do
        it 'decrements the current line_items\' quantity' do
          create(:carted_line_item, product_id: 1, quantity: 2)
          create(:product, id: 1)
          expect { post :create, { product_id: 1, type: 'decrement' } }.to change{ LineItem.last.quantity }.by(-1) 
        end
      end
    end
  end
end