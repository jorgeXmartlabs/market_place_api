class ApplicationController < ActionController::API
  include Authenticable
  include Response
  include ExceptionHandler
end
