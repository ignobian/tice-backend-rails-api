class V1::PagesController < ApplicationController
  def wake_up
  end

  def list_for_xml
    @blogs = Blog.all
    @categories = Category.all
    @tags = Tag.all
    @users = User.all
  end
end
