require "json"

RSpec.describe PostsController, type: "controller" do
  before :each do
    Post.create!(title: "Hello", content: "Hello world!")
    @post_id = Post.find_by(title: "Hello").id
    @new_post = { title: "Goodbye", content: "Goodbye world!" }
  end

  it "lists all posts" do
    login
    get :index
    body = JSON.parse(response.body)

    expect(response.message).to eq "OK"
    expect(body.size).to be 1
    expect(body.first).to include("title" => "Hello", "content" => "Hello world!")
  end

  it "shows a single post by id" do
    login
    get :show, params: { id: @post_id }
    body = JSON.parse(response.body)

    expect(response.message).to eq "OK"
    expect(body).to include("title" => "Hello", "content" => "Hello world!")
  end

  it "creates a new post with admin rights" do
    admin_login
    post :create, params: @new_post
    new_post = Post.find_by(title: "Goodbye")

    expect(new_post.content).to eq "Goodbye world!"
  end

  it "does not create without admin rights" do
    login
    post :create, params: @new_post

    expect(Post.find_by(title: "Goodbye")).to be_nil
  end

  it "updates an existing post by id with admin rights" do
    admin_login
    put :update, params: { id: @post_id,
                           post: @new_post }

    expect(Post.find_by(title: "Hello")).to be_nil
    expect(Post.find_by(title: "Goodbye").content).to eq "Goodbye world!"
  end

  it "does not update without admin rights" do
    login
    put :update, params: { id: @post_id,
                           post: @new_post }

    expect(Post.find_by(title: "Hello")).to be_truthy
    expect(Post.find_by(title: "Goodbye")).to be_nil
  end

  it "deletes an existing post by id with admin rights" do
    admin_login
    delete :destroy, params: { id: @post_id }

    expect(Post.find_by(title: "Hello")).to be_nil
  end

  it "does not delete without admin rights" do
    login
    delete :destroy, params: { id: @post_id }

    expect(Post.find_by(title: "Hello")).to be_truthy
  end
end

private

def login
  user = { email: "test@email.com", password: "testuser123" }
  user.instance_eval do
    def admin?
      return false
    end
  end
  allow(AuthorizeApiRequest).to receive_message_chain(:call, :result){ user }
end

def admin_login
  admin_user = { email: "admin@email.com", password: "admin123" }
  admin_user.instance_eval do
    def admin?
      return true
    end
  end
  allow(AuthorizeApiRequest).to receive_message_chain(:call, :result){ admin_user }
end
