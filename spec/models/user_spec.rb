require 'rails_helper'

describe User do
  it 'has a valid factory' do
    expect(create(:user)).to be_valid
  end
  
  describe 'validations' do
    it 'is invalid without a name' do
      expect(build(:user, name: nil)).to_not be_valid
    end
    
    it 'does not allow duplicated names' do
      create(:user, name: 'same_name')
      expect(build(:user, name: 'same_name')).to_not be_valid
    end
  end
end