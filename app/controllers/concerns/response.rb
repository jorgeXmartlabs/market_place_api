module Response
  def json_response(object, status = :ok)
    render json: Api::V1::UserBlueprint.render(object), status: status
  end

  def exception_response(object, status)
    render json: Api::V1::ExceptionBlueprint.render(object), status: status
  end
end
