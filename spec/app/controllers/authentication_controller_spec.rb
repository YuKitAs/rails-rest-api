RSpec.describe AuthenticationController, type: :controller do
  before :each do
    @email = "example@email.com"
    @password = "example123"
    User.create!(email: @email, password: @password)
  end

  it "logs in a registered user with correct credentials" do
    post :login, params: { email: @email, password: @password }

    expect(response.message).to eq "OK"
    expect(response.body).to include("auth_token")
  end

  it "returns error on incorrect credentials" do
    post :login, params: { email: @email, password: "test123" }

    expect(response.message).to eq "Unauthorized"
  end

  it "returns error on unregistered user" do
    post :login, params: { email: "test@email.com", password: "test123" }

    expect(response.message).to eq "Not Found"
  end
end
