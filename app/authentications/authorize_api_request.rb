class AuthorizeApiRequest
  prepend SimpleCommand

  def initialize(headers = {})
    @headers = headers
  end

  attr_reader :headers

  def call
    return user
  end

  private

  def user
    @user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
  end

  def decoded_auth_token
    @decoded_auth_token ||= JwtService.decode(http_auth_header)
  end

  def http_auth_header
    return headers["Authorization"].split(" ").last if headers["Authorization"].present?
  end
end
