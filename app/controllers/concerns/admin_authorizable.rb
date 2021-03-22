module AdminAuthorizable
  extend ActiveSupport::Concern

  included do
    rescue_from UnpermittedException, with: ->{ render(json: { error: "Forbidden" }, status: 403) }
  end

  def authorize!(action)
    raise(UnpermittedException) if action != :read && !current_user.admin?

    return true
  end
end

class UnpermittedException < StandardError; end
