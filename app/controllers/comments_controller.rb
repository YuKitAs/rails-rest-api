class CommentsController < ApplicationController
  before_action :get_post
  before_action :get_comment, only: [:show, :update, :destroy]

  def index
    authorize!(:read)

    @comment = @post.comments
    render(json: @comment)
  end

  def show
    authorize!(:read)

    render(json: @comment)
  end

  def create
    authorize!(:create)

    @post.comments.create!(comment_params)
  end

  def update
    authorize!(:update)

    @comment.update(comment_params)
  end

  def destroy
    authorize!(:destroy)

    @comment.destroy
  end

  private

  def comment_params
    params.permit(:name, :message)
  end

  def get_post
    @post = Post.find(params[:post_id])
  end

  def get_comment
    @comment = @post.comments.find(params[:id]) if @post
  end
end
