require_relative "../../utils/fixture_reader"
require "json"

RSpec.describe PostsController, type: "controller" do
  before :each do
    posts = read_fixture("posts.json")
    @post = posts["post"]
    @new_post = posts["newPost"]
    Post.create!(@post)
    @post_id = Post.find_by(title: @post["title"]).id
  end

  it "lists all posts" do
    login
    get :index
    body = JSON.parse(response.body)

    expect(response.message).to eq "OK"
    expect(body.size).to be 1
    expect(body.first).to include("title" => @post["title"], "content" => @post["content"])
  end

  it "shows a single post by id" do
    login
    get :show, params: { id: @post_id }
    body = JSON.parse(response.body)

    expect(response.message).to eq "OK"
    expect(body).to include("title" => @post["title"], "content" => @post["content"])
  end

  it "creates a new post with admin rights" do
    admin_login
    post :create, params: @new_post
    new_post = Post.find_by(title: @new_post["title"])

    expect(new_post.content).to eq @new_post["content"]
  end

  it "does not create without admin rights" do
    login
    post :create, params: @new_post

    expect(Post.find_by(title: @new_post["title"])).to be_nil
  end

  it "updates an existing post by id with admin rights" do
    admin_login
    put :update, params: { id: @post_id,
                           post: @new_post }

    expect(Post.find_by(title: @post["title"])).to be_nil
    expect(Post.find_by(title: @new_post["title"]).content).to eq @new_post["content"]
  end

  it "does not update without admin rights" do
    login
    put :update, params: { id: @post_id,
                           post: @new_post }

    expect(Post.find_by(title: @post["title"])).to be_truthy
    expect(Post.find_by(title: @new_post["title"])).to be_nil
  end

  it "deletes an existing post by id with admin rights" do
    admin_login
    delete :destroy, params: { id: @post_id }

    expect(Post.find_by(title: @post["title"])).to be_nil
  end

  it "does not delete without admin rights" do
    login
    delete :destroy, params: { id: @post_id }

    expect(Post.find_by(title: @post["title"])).to be_truthy
  end
end

private

def users
  return read_fixture("users.json")
end

def login
  user = users["testUser"]
  user.instance_eval do
    def admin?
      return false
    end
  end
  allow(AuthorizeApiRequest).to receive_message_chain(:call, :result){ user }
end

def admin_login
  admin_user = users["adminUser"]
  admin_user.instance_eval do
    def admin?
      return true
    end
  end
  allow(AuthorizeApiRequest).to receive_message_chain(:call, :result){ admin_user }
end
