class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler

  before_action :authorize_request
  attr_reader :current_user

  private

  def authorize_request
    @current_user = (AuthorizeApiRequest.new(request.headers).call)[:user]
  end

  def is_mine?(obj)
    obj[:user_id] == current_user.id
  end

  def is_admin?
    current_user.is_admin
  end
end
