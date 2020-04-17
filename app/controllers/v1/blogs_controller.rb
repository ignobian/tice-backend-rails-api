class V1::BlogsController < ApplicationController
  def create
    byebug
    # check if we have at least 1 category and tag
    return render json: { error: 'This blog needs to have at least 1 category' } if params[:categories].empty?
    return render json: { error: 'This blog needs to have at least 1 tag' } if params[:tags].empty?

    @blog = Blog.new(blog_params)
    @blog.slug = @blog.title.slugify

    if !@blog.save
      return render json: { error: @blog.errors.full_messages.first }
    end

    # handle categories and tags
    params[:tags].each do |tag_name|
      # check if tag is already made
      tag = Tag.find_by(name: tag_name)
      if tag.nil?
        # create the tag with the name and slug
        new_tag = Tag.create(name: tag_name, slug: tag_name.slugify)
        # add the tag to the blog post
        @blog.tags << new_tag
      else
        # add the known tag to the blog
        @blog.tags << tag
      end
    end

    # categories
    params[:categories] do |category_id|
      category = Category.find(category_id)
      @blog.categories << category
    end
  end

  private

  def blog_params
    params.permit(:title, :body)
  end
end
