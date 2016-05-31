require 'rails_helper'

describe LineItemsController, type: :controller do
  describe 'POST #create' do
    context 'when cart is empty' do
      it 'creates the line_item' do
        expect { post :create, { product_id: FactoryGirl.create(:product), type: 'add' } }.to change(LineItem, :count).by(1)  
      end
    end
    
    context 'when cart is not empty' do
      context 'when adding a product' do
        context 'when product is same' do
          it 'does not create a new line_item' do
            FactoryGirl.create(:carted_line_item, product_id: 1)
            FactoryGirl.create(:product, id: 1)
            expect { post :create, { product_id: 1, type: 'add' } }.to change(LineItem, :count).by(0) 
          end
          
          it 'increments the current line_items\' quantity' do
            FactoryGirl.create(:carted_line_item, product_id: 1)
            FactoryGirl.create(:product, id: 1)
            expect { post :create, { product_id: 1, type: 'add' } }.to change{ LineItem.last.quantity }.by(1) 
          end
        end

        context 'when product is not same' do
          it 'creates a new line_item' do
            expect { post :create, { product_id: FactoryGirl.create(:product).id, type: 'add' } }.to change(LineItem, :count).by(1) 
          end
        end
      end
      
      context 'when deducting a product' do
        context 'when product is same' do
          it 'does not create a new line_item' do
            
          end
        end
        
        context 'when product is not same' do
          
        end
      end
    end
    
  end
  
  describe 'DELETE #destroy' do
    it 'destroy the line_item'
  end
end