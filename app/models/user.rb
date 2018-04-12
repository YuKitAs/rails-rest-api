class User < ApplicationRecord
  validates :email, uniqueness: true

  has_secure_password
end
