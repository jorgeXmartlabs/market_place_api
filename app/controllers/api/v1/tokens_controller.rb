module Api
  module V1
    # TokensController class
    class TokensController < ApplicationController
      def create
        @user = User.find_by_email(user_params[:email])
        if @user&.authenticate(user_params[:password])
          token = {
            token: JsonWebToken.encode(user_id: @user.id),
            email: @user.email
          }

          token_response(token, :ok)
        else
          head :unauthorized
        end
      end

      private

      # Only allow a trusted parameter "white list" through.
      def user_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end
