class V1::BlogsController < ApplicationController
  before_action :auth_required, except: [:index, :show, :list_related, :with_category_tag, :search, :comments]

  def index
    @blogs = Blog.all
  end

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
    return render json: { error: 'This blog needs to have a featured image' } unless params[:photo].present?

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
    params[:categories].each do |category_id|
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

    # photo upload
    @blog.photo.attach(data: params[:photo], filename: 'featured_image.jpg', content_type: 'image/jpg') if params[:photo].present?

    # handle categories and tags
    # refresh tags
    @blog.blog_tags.destroy_all

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

    # refresh categories
    @blog.blog_categories.destroy_all

    # categories
    params[:categories].each do |category_id|
      category = Category.find(category_id)
      @blog.categories << category
    end
  end

  def destroy
    @blog = Blog.find_by(slug: params[:slug])
    @blog.destroy
  end

  def search
    @blogs = Blog.search(params[:search])
  end

  def advanced_search
    @blogs = Blog.send("search_by_#{params[:option]}(#{params[:query]})")
  end

  def feed
    @blogs = @user.feed_blogs
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

  def with_category_tag
    @blogs = Blog.all.order('created_at DESC').offset(params[:skip]).limit(params[:limit])
    @categories = Category.all
    @tags = Tag.featured
  end

  private

  def blog_params
    params.permit(:title, :body)
  end
end
