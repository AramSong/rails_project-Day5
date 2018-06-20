class BoardController < ApplicationController
  def index
    #모든 post를 받는다
    @posts = Post.all
  end

  def new
  end
  
  def create
    p1 = Post.new
    p1.title = params[:title]
    p1.contents = params[:contents]
    p1.save
    
    redirect_to "/board/#{p1.id}"
  end
  
  def edit
    @post = Post.find(params[:id])
  end
  
  def update
    post = Post.find(params[:id])
    post.title = params[:title]
    post.contents = params[:contents]
    post.save
    
    redirect_to "/board/#{post.id}"
  end
  
  def destroy
    post = Post.find(params[:id])
    post.destroy
    
    redirect_to "/boards"
  end
  
  def show
    @post = Post.find(params[:id])
  end
  
end
