RSpec.describe User, type: :model do
  it{ should have_secure_password }

  it{ should validate_presence_of(:email) }

  describe "uniqueness" do
    subject{ User.new(email: "test@email.com", password: "nopassword") }
    it{ should validate_uniqueness_of(:email) }
  end
end
