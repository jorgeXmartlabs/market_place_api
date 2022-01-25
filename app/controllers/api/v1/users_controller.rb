module Api
  module V1
    # User Controller
    class UsersController < ApplicationController
      before_action :check_owner, only: %i[update destroy]
      wrap_parameters :user, include: %i[email password]
      rescue_from (ActiveRecord::RecordNotFound) { |exception| handle_not_found(exception) }

      # GET /users/1
      def show
        render json: Api::V1::UserBlueprint.render(user)
      end

      # POST /users
      def create
        user = User.new(user_params)

        if user.save
          render json: Api::V1::UserBlueprint.render(user), status: :created
        else
          render json: user.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /users/1
      def update
        if user.update(user_params)
          render json: user, status: :ok
        else
          render json: user.errors, status: :unprocessable_entity
        end
      end

      # DELETE /users/1
      def destroy
        user.destroy
        head 204
      end

      private

      # Only allow a trusted parameter "white list" through.
      def user_params
        params.require(:user).permit(:email, :password)
      end

      def user
        @user ||= User.find(params[:id])
      end

      def handle_not_found(exception)
        render json: { message: exception.message }, status: :not_found
      end

      def check_owner
        head :forbidden unless @user.id == current_user&.id
      end
    end
  end
end
