module Api
  module V1
    # User Controller
    class UsersController < ApplicationController
      before_action :check_owner, only: %i[update destroy]
      wrap_parameters :user, include: %i[email password]

      # GET /users/:id
      def show
        json_response(user)
      end

      # POST /users
      def create
        user = User.create!(user_params)
        json_response(user, :created)
      end

      # PATCH/PUT /users/:id
      def update
        user.update(user_params)
        json_response(user)
      end

      # DELETE /users/:id
      def destroy
        user.destroy
        head :no_content
      end

      private

      # Only allow a trusted parameter "white list" through.
      def user_params
        params.permit(:email, :password)
      end

      def user
        @user ||= User.find(params[:id])
      end

      def check_owner
        head :forbidden unless @user.id == current_user&.id
      end
    end
  end
end
