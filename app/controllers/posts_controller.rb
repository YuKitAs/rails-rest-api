class PostsController < ApplicationController
  def index
    @posts = Post.all
    render(json: @posts)
  end

  def show
    @post = Post.find(params[:id])
    render(json: @post)
  end

  def create
    @post = Post.new(params.permit(:title, :content))
    @post.save
  end

  def update
    @post = Post.find(params[:id])
    @post.update(post_params)
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
  end

  private

  def post_params
    params.require(:post).permit(:title, :content)
  end
end
