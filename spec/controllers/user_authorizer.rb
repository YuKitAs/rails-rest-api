class UserAuthorizer
  def self.current_user(access_level)
    current_user = User.new(email: "test@email.com", password: "nopassword")

    current_user.instance_exec(access_level) do |level|
      define_singleton_method(:admin?) do
        return level == :admin
      end
    end

    return current_user
  end
end
