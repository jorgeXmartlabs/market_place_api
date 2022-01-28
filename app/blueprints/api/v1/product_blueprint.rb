module Api
  module V1
    class ProductBlueprint < Blueprinter::Base
      identifier :id

      view :normal do
        fields :title, :price, :published
        association :user, blueprint: UserBlueprint
      end
    end
  end
end
