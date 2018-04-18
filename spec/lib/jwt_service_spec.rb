RSpec.describe JwtService do
  before :each do
    @payload = { user_id: 42 }
  end

  it "encodes payload correctly" do
    token = JwtService.encode(@payload)

    expect(JwtService.decode(token)).to include("user_id" => 42, "exp" => 24.hours.from_now.to_i)
  end

  it "decodes token correctly" do
    token = JwtService.encode(@payload)
    payload = JwtService.decode(token)

    expect(payload["user_id"]).to be 42
    expect(payload).to include("exp")
  end

  it "returns nil on incorrect token" do
    token = "hello.world"

    expect(JwtService.decode(token)).to be_nil
  end
end
