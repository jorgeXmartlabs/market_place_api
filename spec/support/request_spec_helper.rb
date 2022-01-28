module RequestSpecHelper
  # Parse JSON response to ruby hash
  def json
    JSON.parse(response.body, symbolize_names: true)
  end

  # generate tokens from user id
  def token_generator(user_id)
    JsonWebToken.encode(user_id: user_id)
  end
end
