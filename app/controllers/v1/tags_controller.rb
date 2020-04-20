class V1::TagsController < ApplicationController
  before_action :admin_required, only: [:create, :destroy]

  def index
    @tags = Tag.all
  end

  def show
    @tag = Tag.find_by(slug: params[:slug])
    if @tag.nil?
      return render json: { error: 'Tag not found' }
    end
  end

  def create
    @tag = Tag.new(tag_params)
    @tag.slug = @tag.name.slugify
    if !@tag.save
      return render json: { error: @tag.errors.full_messages }
    end
  end

  def destroy
    @tag = Tag.find_by(slug: params[:slug])
    @tag.destroy
  end

  def featured
    @tags = Tag.featured
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end
