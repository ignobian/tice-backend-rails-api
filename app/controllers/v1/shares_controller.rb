class V1::SharesController < ApplicationController
  before_action :auth_required, only: [:create]

  def create
    @share = Share.new(share_params)
    @share.user = @user

    if !@share.save
      return render json: { message: @share.errors.full_messages.first }
    end
  end

  def add_not_signed_in
    # check if share doesnt exist with user agent
    @blog = Blog.find(share_params[:blog_id])
    share_type = share_params[:share_type]
    user_agent = request.headers['user-agent']

    found = Share.find_by(blog: @blog, share_type: share_type, user_agent: user_agent)
    unless found.nil?
      return render json: { message: 'This user agent already shared this post this way' }
    end

    # add the user agent
    @share = Share.new(blog: @blog, share_type: share_type, user_agent: user_agent)
    if !@share.save
      return render json: { message: @share.errors.full_messages.first }
    end
  end

  private

  def share_params
    params.require(:share).permit(:share_type, :blog_id)
  end
end
