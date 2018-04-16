class ApplicationController < ActionController::API
  include TokenAuthenticatable
  include AdminAuthorizable

  rescue_from ActiveRecord::RecordNotFound, with: ->{ render json: { error: "Not Found" }, status: 404 }
  rescue_from ActiveRecord::RecordInvalid, with: ->{ render json: { error: "Bad Request" }, statsu: 400 }
end
