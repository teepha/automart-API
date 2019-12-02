module Response
  def json_response(response, status)
    render json: response, status: status
  end
end
