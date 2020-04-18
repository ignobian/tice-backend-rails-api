class V1::ImpressionsController < ApplicationController
  before_action :auth_required, only: [:create]

  def create
    @impression = Impression.new(impression_params)
    @impression.user = @user

    if !@impression.save
      return render json: { message: @impression.errors.full_messages.first }
    end
  end

  def add_not_signed_in
    # check if impression doesnt exist with user agent
    @blog = Blog.find(impression_params[:blog_id])
    user_agent = request.headers['user-agent']

    found = Impression.find_by(blog: @blog, user_agent: user_agent)
    unless found.nil?
      return render json: { message: 'This user agent already impressiond this post' }
    end

    # add the user agent
    @impression = Impression.new(blog: @blog, user_agent: user_agent)
    if !@impression.save
      return render json: { message: @impression.errors.full_messages.first }
    end
  end

  private

  def impression_params
    params.require(:impression).permit(:blog_id)
  end
end
