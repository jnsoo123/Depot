require 'rails_helper'

describe Product do
  it 'has a valid factory' do
    expect(create(:product)).to be_valid  
  end
  
  describe 'validations' do
    it 'is invalid without a title' do
      expect(build(:product, title: nil)).to_not be_valid
    end

    it 'is invalid without a description' do
      expect(build(:product, description: nil)).to_not be_valid  
    end

    it 'is invalid without a image_url' do
      expect(build(:product, image_url: nil)).to_not be_valid  
    end

    it 'is invalid without a category_id' do 
      expect(build(:product, category_id: nil)).to_not be_valid  
    end

    it 'does not allow duplicate titles' do 
      create(:product, title: 'test1')
      expect(build(:product, title: 'test1')).to_not be_valid
    end

    it 'does not allow prices with less than 0.01' do
      expect(build(:product, price: 0)).to_not be_valid
      expect(build(:product, price: -1)).to_not be_valid
      expect(build(:product, price: 'abc')).to_not be_valid
    end

    it 'does not allow image_url being other than GIF, JPG, and PNG' do
      expect(build(:product, image_url: 'test.docx')).to_not be_valid
    end
  end
  describe 'methods' do
    context 'self.latest' do
      context 'has an updated product' do
        it 'updates cache' do
          current_product = create(:product)
          updated_product = create(:product, title: 'test2', description: 'test2', image_url: 'test2.jpg', category_id: 2, price: 13)
          expect(Product.latest).to eq(updated_product)
        end
      end

      context 'does not have an updated product' do
        it 'does not update cache' do
          current_product = create(:product)
          expect(Product.latest).to eq(current_product)
        end
      end
    end
  
    context 'ensure_not_referenced_by_any_line_item' do
      before(:each) do
        @product = create(:product, id: 1)
      end

      context 'doesn\'t have  a referenced line_item' do
        it 'returns true' do
          expect(@product.instance_eval { ensure_not_referenced_by_any_line_item } ).to eq(true)
        end
      end

      context 'has a referenced line_item' do
        it 'does not destroy the product' do 
          create(:line_item, product_id: 1)
          expect(@product.instance_eval { ensure_not_referenced_by_any_line_item } ).to eq(false)
        end
      end
    end
  end
end