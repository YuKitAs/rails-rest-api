require_relative '../../rails_helper'
require 'controllers/posts_controller'
require 'json'

RSpec.describe PostsController, type: 'controller' do
  before :each do
    Post.create(title: 'Hello', content: 'Hello world!')
    @post_id = (Post.find_by title: 'Hello').id
    @new_post = { title: 'Goodbye', content: 'Goodbye world!' }
  end

  it 'lists all posts' do
    get :index
    body = JSON.parse(response.body)

    expect(response.message).to eq 'OK'
    expect(body.size).to be 1
    expect(body.first).to include('title' => 'Hello', 'content' => 'Hello world!')
  end

  it 'shows a single post by id' do
    get :show, params: { id: @post_id }
    body = JSON.parse(response.body)

    expect(response.message).to eq 'OK'
    expect(body).to include('title' => 'Hello', 'content' => 'Hello world!')
  end

  it 'creates a new post' do
    post :create, params: @new_post
    new_post = Post.find_by title: 'Goodbye'

    expect(response.message).to eq 'No Content'
    expect(new_post.content).to eq 'Goodbye world!'
  end

  it 'updates an existing post by id' do
    put :update, params: { id: @post_id,
                           post: @new_post }

    expect(response.message).to eq 'No Content'
    expect(Post.find_by(title: 'Hello')).to be nil
    expect(Post.find_by(title: 'Goodbye').content).to eq 'Goodbye world!'
  end

  it 'deletes an existing post by id' do
    delete :destroy, params: { id: @post_id }

    expect(response.message).to eq 'No Content'
    expect(Post.find_by(title: 'Hello')).to be nil
  end
end
