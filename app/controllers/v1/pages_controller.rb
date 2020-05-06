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
end
