module Api
  module V1
    class UserBlueprint < Blueprinter::Base
      identifier :id

      fields :email, :created_at, :updated_at
    end
  end
end
