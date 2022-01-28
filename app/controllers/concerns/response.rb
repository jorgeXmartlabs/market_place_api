module Response
  def json_response(object, status = :ok)
    render json: Api::V1::UserBlueprint.render(object), status: status
  end

  def product_response(object, status = :ok)
    render json: Api::V1::ProductBlueprint.render(object), status: status
  end

  def token_response(object, status = :ok)
    render json: Api::V1::TokenBlueprint.render(object), status: status
  end

  def exception_response(object, status)
    render json: Api::V1::ExceptionBlueprint.render(object), status: status
  end
end
