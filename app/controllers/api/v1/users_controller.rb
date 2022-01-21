module Api
  module V1
    # User Controller
    class UsersController < ApplicationController
      # GET /users/1
      def show
        render json: User.find(params[:id])
      end
    end
  end
end
