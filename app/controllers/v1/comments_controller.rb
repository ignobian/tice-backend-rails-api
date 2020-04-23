class V1::CommentsController < ApplicationController
  def create
    byebug
  end

  def from_blog
    @blog = Blog.find_by(slug: params[:slug])
    if @blog.nil?
      return render json: { error: 'Blog not found' }
    end
    @comments = @blog.comments
  end
end
