module Api
  module V1
    # Product Controller
    class ProductsController < ApplicationController

      # GET /products
      def index
        products = Product.all
        product_response(products)
      end

      # GET /products/:id
      def show
        product_response(product)
      end

      def product
        @product ||= Product.find(params[:id])
      end
    end
  end
end
