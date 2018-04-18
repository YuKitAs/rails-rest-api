class ApplicationController < ActionController::API
  include TokenAuthenticatable
  include AdminAuthorizable
  include RecordAccessible
end
