require_relative "user_authorizer"

RSpec.describe CommentsController, type: "controller" do
  before :each do
    comments = JSON.parse(file_fixture("comments.json").read)
    @comment = comments["comment"]
    @new_comment = comments["newComment"]

    post = JSON.parse(file_fixture("posts.json").read)["post"]
    Post.create!(post)
    post_record = Post.find_by(title: post["title"], content: post["content"])

    @post_id = post_record.id
    @post_comments = post_record.comments
    @post_comments.create!(@comment)

    @comment_id = @post_comments.first.id

    @new_comment_params = { post_id: @post_id, name: @new_comment["name"], message: @new_comment["message"] }
  end

  it "lists all comments of a post" do
    login(:user)
    get :index, params: { post_id: @post_id }
    body = JSON.parse(response.body)

    expect(response.message).to eq "OK"
    expect(body.size).to be 1
    expect(body.first).to include("name" => @comment["name"], "message" => @comment["message"])
  end

  it "shows a single comment by id of a post" do
    login(:user)
    get :show, params: { post_id: @post_id, id: @comment_id }
    body = JSON.parse(response.body)

    expect(response.message).to eq "OK"
    expect(body).to include("name" => @comment["name"], "message" => @comment["message"])
  end

  it "creates a new comment with admin rights" do
    expect(@post_comments.find_by(name: @new_comment["name"])).to be_nil

    login(:admin)
    post :create, params: @new_comment_params
    new_comment = @post_comments.find_by(name: @new_comment["name"])

    expect(new_comment.message).to eq(@new_comment["message"])
  end

  it "does not create comment without admin rights" do
    login(:user)
    post :create, params: @new_comment_params

    expect(response.message).to eq "Forbidden"
    expect(@post_comments.find_by(name: @new_comment["name"])).to be_nil
  end

  it "updates an existing comment by id with admin rights" do
    @new_comment_params[:id] = @comment_id

    login(:admin)
    put :update, params: @new_comment_params

    expect(@post_comments.find_by(name: @comment["name"])).to be_nil
    expect(@post_comments.find_by(name: @new_comment["name"]).message).to eq @new_comment["message"]
  end

  it "does not update comment without admin rights" do
    @new_comment_params[:id] = @comment_id

    login(:user)
    put :update, params: @new_comment_params

    expect(response.message).to eq "Forbidden"
    expect(@post_comments.find_by(name: @comment["name"])).to be_truthy
    expect(@post_comments.find_by(name: @new_comment["name"])).to be_nil
  end

  it "deletes an existing comment by id of a post" do
    login(:admin)
    delete :destroy, params: { post_id: @post_id, id: @comment_id }

    expect(@post_comments.find_by(name: @comment["name"])).to be_nil
  end

  it "does not delete comment without admin rights" do
    login(:user)
    delete :destroy, params: { post_id: @post_id, id: @comment_id }

    expect(response.message).to eq "Forbidden"
    expect(@post_comments.find_by(name: @comment["name"])).to be_truthy
  end
end

private

def login(access_level)
  allow(AuthorizeApiRequest).to receive_message_chain(:call, :result){ UserAuthorizer.current_user(access_level) }
end
