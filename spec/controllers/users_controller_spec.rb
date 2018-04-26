RSpec.describe UsersController, type: :controller do
  before :each do
    @test_user = JSON.parse(file_fixture("users.json").read)["testUser"]
    User.create!(@test_user)
  end

  describe "POST #register" do
    context "with valid attributes" do
      it "creates a new user" do
        post :register, params: { email: "newuser@email.com", password: "newuser123" }

        expect(response.message).to eq "Created"
        expect(User.find_by(email: "newuser@email.com")).to be_truthy
      end
    end

    context "with invalid attributes" do
      it "does not create without email field" do
        post :register, params: { password: @test_user["password"] }

        expect(JSON.parse(response.body)).to include("error" => "Bad Request")
      end

      it "does not create duplicate user" do
        post :register, params: { email: @test_user["email"], password: @test_user["password"] }

        expect(JSON.parse(response.body)).to include("error" => "Bad Request")
      end
    end
  end
end
