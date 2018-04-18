class UserAuthorizer
  def self.current_user(authorizee)
    user = User.new(email: "test@email.com", password: "nopassword")

    if authorizee == :admin
      user.instance_eval do
        def admin?
          return true
        end
      end
    else
      user.instance_eval do
        def admin?
          return false
        end
      end
    end

    return user
  end
end
