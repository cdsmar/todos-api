# app/controllers/concerns/response.rb
module Response
  # JSON response with status code
  def json_response(object, status = :ok)
    render json: object, status: status
  end
end
