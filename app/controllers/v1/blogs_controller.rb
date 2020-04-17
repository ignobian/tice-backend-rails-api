class V1::BlogsController < ApplicationController
  def create
    byebug
    @blog = Blog.new(blog_params)
    @blog.slug = @blog.name.slugify

    if !@blog.save
      return render json: { error: @blog.errors.full_messages.first }
    end
  end

  private

  def blog_params
    params.permit(:title, :body, :categories, :tags, :photo)
  end
end
