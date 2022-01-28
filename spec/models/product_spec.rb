require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:product) { create :product }

  describe 'validations' do
    it 'should have valid attributes' do
      expect(product).to be_valid
    end

    it 'should have a positive price' do
      product.price = -1
      expect(product).not_to be_valid
    end

    it 'is invalid without title' do
      product.title = nil
      expect(product).not_to be_valid
    end

    it 'is invalid without price' do
      product.price = nil
      expect(product).not_to be_valid
    end

    it 'is invalid without user_id' do
      product.user = nil
      expect(product).not_to be_valid
    end
  end
end
