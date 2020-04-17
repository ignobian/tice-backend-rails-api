class V1::CategoriesController < ApplicationController
  before_action :admin_required, only: [:create, :destroy]
  def index
    @categories = Category.all
  end

  def show
    @category = Category.find_by(slug: params[:slug])
  end

  def create
    @category = Category.new(category_params)
    if !@category.save
      return render json: { error: @category.errors.full_messages }
    end
  end

  def destroy
    @category = Category.find_by(slug: params[:slug])
    @category.destroy
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
