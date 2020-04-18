class V1::BlogsController < ApplicationController
  before_action :auth_required, except: [:show, :list_related]

  def show
    @blog = Blog.find_by(slug: params[:slug])
    if @blog.nil?
      return render json: { error: 'Blog not found' }
    end
  end

  def from_user
    @blogs = Blog.where(user: @user)
  end

  def create
    # check if we have at least 1 category and tag
    return render json: { error: 'This blog needs to have at least 1 category' } if params[:categories].empty?
    return render json: { error: 'This blog needs to have at least 1 tag' } if params[:tags].empty?

    @blog = Blog.new(blog_params)
    @blog.slug = @blog.title.slugify
    @blog.user = @user

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

    # photo upload
    @blog.photo.attach(data: params[:photo], filename: 'featured_image.jpg', content_type: 'image/jpg') if params[:photo].present?
  end

  def update
    # check if we have at least 1 category and tag
    return render json: { error: 'This blog needs to have at least 1 category' } if params[:categories].empty?
    return render json: { error: 'This blog needs to have at least 1 tag' } if params[:tags].empty?

    @blog = Blog.find_by(slug: params[:slug])
    return render json: { error: 'Blog not found' } if @blog.nil?

    if !@blog.update(blog_params)
      return render json: { error: @blog.errors.full_messages.first }
    end

    byebug
  end

  def add_clap
    @blog = Blog.find_by(slug: params[:slug])
    @clap = Clap.new(user: @user, blog: @blog)

    if !@clap.save
      return render json: { error: @clap.errors.full_messages.first }
    end
  end

  def list_related
    @blog = Blog.find(params[:id])
  end

  private

  def blog_params
    params.permit(:title, :body)
  end
end
