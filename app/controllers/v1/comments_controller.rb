class V1::CommentsController < ApplicationController
  before_action :auth_required, only: [:create]

  def create
    @comment = Comment.new(comment_params)

    @comment.user = @user
    @comment.blog = Blog.find(params[:blog_id])

    if !@comment.save
      return render json: { error: @comment.errors.full_messages.first }
    end
  end

  def from_blog
    @blog = Blog.find_by(slug: params[:slug])
    if @blog.nil?
      return render json: { error: 'Blog not found' }
    end
    @comments = @blog.comments
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
