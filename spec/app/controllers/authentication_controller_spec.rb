require_relative "../../utils/fixture_reader"

RSpec.describe AuthenticationController, type: :controller do
  before :each do
    users = read_fixture("users.json")
    @email = users["testUser"]["email"]
    @password = users["testUser"]["password"]
    User.create!(email: @email, password: @password)
  end

  it "logs in a registered user with correct credentials" do
    post :login, params: { email: @email, password: @password }

    expect(response.message).to eq "OK"
    expect(response.body).to include("auth_token")
  end

  it "returns error on incorrect credentials" do
    post :login, params: { email: @email, password: "nopassword" }

    expect(response.message).to eq "Unauthorized"
  end

  it "returns error on unregistered user" do
    post :login, params: { email: "nouser@email.com", password: "nopassword" }

    expect(response.message).to eq "Not Found"
  end
end
