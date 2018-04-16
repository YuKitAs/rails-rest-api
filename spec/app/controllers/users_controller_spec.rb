require_relative "../../utils/fixture_reader"

RSpec.describe UsersController, type: :controller do
  before :each do
    users = read_fixture("users.json")
    @email = users["testUser"]["email"]
    @password = users["testUser"]["password"]
    User.create!(email: @email, password: @password)
  end

  it "creates a new user" do
    post :register, params: { email: "newuser@email.com", password: "newuser123" }

    expect(response.message).to eq "Created"
    expect(User.find_by(email: "newuser@email.com")).to be_truthy
  end

  it "does not create without email field" do
    post :register, params: { password: @password }

    expect(JSON.parse(response.body)).to include("error" => "Bad Request")
  end

  it "does not create duplicate user" do
    post :register, params: { email: @email, password: @password }

    expect(JSON.parse(response.body)).to include("error" => "Bad Request")
  end
end
