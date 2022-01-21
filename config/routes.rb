Rails.application.routes.draw do
  # Api definition
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      # List our resources here
    end
  end
end
