module Api
  module V1
    # Product Controller
    class ProductsController < ApplicationController

      # GET /product/:id
      def show
        product_response(product)
      end

      def product
        @product ||= Product.find(params[:id])
      end
    end
  end
end
