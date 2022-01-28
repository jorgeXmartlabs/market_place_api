module Api
  module V1
    class TokenBlueprint < Blueprinter::Base
      fields :token, :email
    end
  end
end
