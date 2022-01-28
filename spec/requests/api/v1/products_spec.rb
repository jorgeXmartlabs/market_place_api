require 'rails_helper'

RSpec.describe 'Products API', type: :request do

  describe 'GET /product/:id' do
    let!(:product) { create(:product) }
    let(:product_id) { product.id }
    let(:serializer) { Api::V1::ProductBlueprint }

    before { get api_v1_product_path(product_id) }

    context 'when the product exits' do
      it 'returns status code 200' do
        expect(response).to have_http_status :ok
      end

      it 'returns the product' do
        expect(json).to eql serializer.render_as_hash(product)
      end
    end

    context 'when the user does not exits' do
      let(:product_id) { 1000 }

      it 'returns status code 404' do
        expect(response).to have_http_status :not_found
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Product/)
      end
    end
  end
end