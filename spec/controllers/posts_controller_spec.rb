require_relative "user_authorizer"
require "json"

RSpec.describe PostsController, type: "controller" do
  before :each do
    posts = JSON.parse(file_fixture("posts.json").read)
    @post = posts["post"]
    @new_post = posts["newPost"]
    Post.create!(@post)

    @post_id = Post.find_by(title: @post["title"]).id
  end

  it "lists all posts" do
    login(:user)
    get :index
    body = JSON.parse(response.body)

    expect(response.message).to eq "OK"
    expect(body.size).to be 1
    expect(body.first).to include("title" => @post["title"], "content" => @post["content"])
  end

  it "shows a single post by id" do
    login(:user)
    get :show, params: { id: @post_id }
    body = JSON.parse(response.body)

    expect(response.message).to eq "OK"
    expect(body).to include("title" => @post["title"], "content" => @post["content"])
  end

  it "creates a new post with admin rights" do
    expect(Post.find_by(title: @new_post["title"])).to be_nil

    login(:admin)
    post :create, params: @new_post
    new_post = Post.find_by(title: @new_post["title"])

    expect(new_post.content).to eq @new_post["content"]
  end

  it "does not create post without admin rights" do
    login(:user)
    post :create, params: @new_post

    expect(response.message).to eq "Forbidden"
    expect(Post.find_by(title: @new_post["title"])).to be_nil
  end

  it "updates an existing post by id with admin rights" do
    login(:admin)
    put :update, params: { id: @post_id,
                           post: @new_post }

    expect(Post.find_by(title: @post["title"])).to be_nil
    expect(Post.find_by(title: @new_post["title"]).content).to eq @new_post["content"]
  end

  it "does not update post without admin rights" do
    login(:user)
    put :update, params: { id: @post_id,
                           post: @new_post }

    expect(response.message).to eq "Forbidden"
    expect(Post.find_by(title: @post["title"])).to be_truthy
    expect(Post.find_by(title: @new_post["title"])).to be_nil
  end

  it "deletes an existing post by id with admin rights" do
    login(:admin)
    delete :destroy, params: { id: @post_id }

    expect(Post.find_by(title: @post["title"])).to be_nil
  end

  it "does not delete post without admin rights" do
    login(:user)
    delete :destroy, params: { id: @post_id }

    expect(response.message).to eq "Forbidden"
    expect(Post.find_by(title: @post["title"])).to be_truthy
  end
end

private

def login(authorizee)
  allow(AuthorizeApiRequest).to receive_message_chain(:call, :result){ UserAuthorizer.current_user(authorizee) }
end
