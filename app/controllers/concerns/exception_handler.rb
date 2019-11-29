module ExceptionHandler
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end
  class AuthorizationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end

  included do 
    rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::MissingToken, with: :four_zero_three
    rescue_from ExceptionHandler::InvalidToken, with: :four_twenty_two

    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ error: e.message }, :not_found)
    end

    rescue_from ExceptionHandler::AuthenticationError do |e|
      json_response({ error: e.message }, :bad_request) 
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      error_msg = Message.invalid_credentials
      error_msg = Message.account_exists if e.message.match?(/already been taken/)
      json_response({ error: error_msg }, :unprocessable_entity)
    end
  end

  private

  def four_twenty_two(e)
    json_response({ error: e.message }, :unprocessable_entity)
  end

  def four_zero_three(e)
    json_response({ error: e.message }, :forbidden)
  end

  def unauthorized_request(e)
    json_response({ error: e.message }, :unauthorized)
  end
end
