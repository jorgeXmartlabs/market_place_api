module Api
  module V1
    # Product Controller
    class ProductsController < ApplicationController
      before_action :check_login, only: %i[create]
      before_action :check_owner, only: %i[update destroy]

      # GET /products
      def index
        products = Product.all
        product_response(products)
      end

      # GET /products/:id
      def show
        product_response(product)
      end

      # POST /products
      def create
        product = current_user.products.build(product_params)
        if product.save
          product_response(product, :created)
        else
          exception_response({ 'message': product.errors }, :unprocessable_entity)
        end
      end

      # DELETE /products/:id
      def destroy
        product.destroy
        head 204
      end

      def product
        @product ||= Product.find(params[:id])
      end

      def product_params
        params.require(:product).permit(:title, :price, :published)
      end

      def check_owner
        head :forbidden unless product.user_id == current_user&.id
      end
    end
  end
end
