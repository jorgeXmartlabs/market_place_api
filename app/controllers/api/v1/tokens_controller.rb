module Api
  module V1
    # TokensController class
    class TokensController < ApplicationController
      def create
        @user = User.find_by_email(user_params[:email])
        # & -> Safe Navigation Operator
        # Please note, below code uses instance variables.
        # If you want to use safe navigation operator with local variables,
        # you will have to check that your local variables are defined first.
        if @user&.authenticate(user_params[:password])
          render json: {
            token: JsonWebToken.encode(user_id: @user.id),
            email: @user.email
          }
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
