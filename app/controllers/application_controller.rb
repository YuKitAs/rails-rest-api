class ApplicationController < ActionController::API
  rescue_from StandardError, with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  before_action :authenticate_request
  attr_reader :current_user

  def not_found
    render(json: { error: "Not found" }, status: 404)
  end

  def exception
    render(json: { error: "Internal server error" }, status: 500)
  end

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render(json: { error: "Unauthorized" }, status: 401) unless @current_user
  end
end
