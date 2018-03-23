class ApplicationController < ActionController::API
  rescue_from StandardError, with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def not_found
    render json: { error: 'not-found' }.to_json, status: 404
  end

  def exception
    render json: { error: 'internal-server-error' }.to_json, status: 500
  end
end
