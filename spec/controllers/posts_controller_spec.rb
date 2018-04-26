require_relative "user_authorizer"

RSpec.describe PostsController, type: "controller" do
  before :each do
    posts = JSON.parse(file_fixture("posts.json").read)
    @post = posts["post"]
    @new_post = posts["newPost"]
    @post_id = Post.create!(@post).to_param
  end

  describe "GET #index" do
    it "lists all posts" do
      login(:user)
      Post.create!(@new_post)
      get :index

      expect(response).to be_success
      expect(JSON.parse(response.body).size).to be 2
    end
  end

  describe "GET #show" do
    it "shows a single post by id" do
      login(:user)
      get :show, params: { id: @post_id }
      body = JSON.parse(response.body)

      expect(response).to be_success
      expect(body["title"]).to eq @post["title"]
      expect(body["content"]).to eq @post["content"]
    end
  end

  describe "POST #create" do
    context "with admin rights" do
      it "creates a new post" do
        expect(Post.find_by(title: @new_post["title"])).to be_nil

        login(:admin)
        post :create, params: @new_post

        expect(Post.find_by(title: @new_post["title"]).content).to eq @new_post["content"]
      end
    end

    context "without admin rights" do
      it "does not create post" do
        login(:user)
        post :create, params: @new_post

        expect(response.message).to eq "Forbidden"
        expect(Post.find_by(title: @new_post["title"])).to be_nil
      end
    end
  end

  describe "PUT #update" do
    context "with admin rights" do
      it "updates an existing post by id" do
        expect(Post.find_by(title: @post["title"]).content).to eq @post["content"]

        login(:admin)
        put :update, params: { id: @post_id, post: @new_post }

        expect(Post.find_by(title: @post["title"])).to be_nil
        expect(Post.find(@post_id).title).to eq @new_post["title"]
        expect(Post.find(@post_id).content).to eq @new_post["content"]
      end
    end

    context "without admin rights" do
      it "does not update post" do
        login(:user)
        put :update, params: { id: @post_id, post: @new_post }

        expect(response.message).to eq "Forbidden"
        expect(Post.find_by(title: @post["title"]).content).to eq @post["content"]
        expect(Post.find_by(title: @new_post["title"])).to be_nil
      end
    end
  end

  describe "DELETE #destroy" do
    context "with admin rights" do
      it "deletes an existing post by id" do
        login(:admin)
        delete :destroy, params: { id: @post_id }

        expect(Post.find_by(title: @post["title"])).to be_nil
      end
    end

    context "without admin rights" do
      it "does not delete post" do
        login(:user)
        delete :destroy, params: { id: @post_id }

        expect(response.message).to eq "Forbidden"
        expect(Post.find(@post_id)).to be_truthy
      end
    end
  end
end

private

def login(access_level)
  allow(AuthorizeApiRequest).to receive_message_chain(:call, :result){ UserAuthorizer.current_user(access_level) }
end
