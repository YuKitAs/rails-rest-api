require "jwt"

RSpec.describe AuthenticationController, type: :controller do
  before :each do
    User.create!(email: "example@email.com", password: "example123")
  end

  it "logs in a registered user with correct credentials" do
    post :login, params: { email: "example@email.com", password: "example123" }

    expect(response.message).to eq "OK"
    expect(response.body).to include("auth_token")
  end

  it "returns error on incorrect credentials" do
    post :login, params: { email: "test@email.com", password: "test123" }

    expect(response.message).to eq "Unauthorized"
  end
end
