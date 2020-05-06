class V1::PagesController < ApplicationController
  def wake_up
  end

  def list_for_xml
    @blogs = Blog.all
    @categories = Category.all
    @tags = Tag.all
    @users = User.all
  end

  def index_xml
    @categories = Category.all
    @last_mod = Blog.last_modified
  end

  def main_xml
    @users = User.not_deleted
    @last_mod = Blog.last_modified
  end

  def get_category_xml
    @category = Category.find_by(slug: params[:slug])
    @blogs = @category.blogs
  end
end
