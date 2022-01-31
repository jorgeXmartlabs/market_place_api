require 'rails_helper'

RSpec.describe 'Products API', type: :request do
  let!(:products) { create_list(:product, 10) }
  let(:product) { products.first }
  let(:product_id) { product.id }
  let(:user) { product.user }
  let(:user_id) { user.id }
  let(:serializer) { Api::V1::ProductBlueprint }
  let(:headers) { { 'Authorization' => token_generator(user_id) } }

  describe 'Get /products' do
    before { get api_v1_products_path }

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns products' do
      expect(json.size).to eq(10)
      expect(json).to eql serializer.render_as_hash(products)
    end
  end

  describe 'GET /products/:id' do
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

  describe 'DELETE /products/:id' do
    context 'when the product exists' do
      before { delete api_v1_product_path(product_id), headers: headers }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the product does not exists' do
      before { delete api_v1_product_path(10_000) }

      it 'returns status code 404' do
        expect(response).to have_http_status :not_found
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Product/)
      end
    end
  end
end