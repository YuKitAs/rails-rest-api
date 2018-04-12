RSpec.describe UsersController, type: :controller do
  it "creates a new user" do
    post :register, params: { email: "example@email.com", password: "example123" }

    expect(response.message).to eq "Created"
    expect(User.find_by(email: "example@email.com")).to be_truthy
  end
end
