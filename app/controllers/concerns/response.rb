module Response
  def json_response(object, status = :ok)
    render json: Api::V1::UserBlueprint.render(object), status: status
  end
end
