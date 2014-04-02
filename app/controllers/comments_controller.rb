class CommentsController < ApplicationController
  before_filter :load_commentable
  def new
  end

  def create
    @comment =  @commentable.comments.new(params[:comment])
    @comment.commenter = current_user
    if @comment.save
      redirect_to :back, :notice => 'Comment added'
    else
      flash[:alert] = "Content can't be empty"
      redirect_to :back
    end
  end

  def edit
  end

  def show
  end

  private

  def load_commentable
    @commentable = CommentableHandler.load_commentable(request)
  end
end
