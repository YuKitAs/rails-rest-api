class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  def login
    command = AuthenticateUser.call(params[:email], params[:password])

    if command.successful?
      render(json: { auth_token: command.result })
    else
      render(json: { error: command.errors }, status: :unauthorized)
    end
  end
end
