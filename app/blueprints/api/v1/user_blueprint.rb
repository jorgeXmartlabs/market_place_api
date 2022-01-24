module Api
  module V1
    class UserBlueprint < Blueprinter::Base
      identifier :id

      fields :email
    end
  end
end
