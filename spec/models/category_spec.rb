require 'rails_helper'

describe Category do
  it 'has a valid factory' do
    expect(create(:category)).to be_valid
  end
  describe 'validations' do
    it 'is invalid without a name' do
      expect(build(:invalid_category)).to_not be_valid
    end

    it 'does not allow duplicate name' do
      create :category, name: 'same_name'
      expect(build(:category, name: 'same_name')).to_not be_valid
    end
  end
end