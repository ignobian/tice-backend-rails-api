class V1::UsersController < ApplicationController
  before_action :auth_required

  def index
    @users = User.all
  end

  def edit
  end

  def update
    if !@user.update(user_params)
      return render json: { error: @user.errors.full_messages.first }
    end

    # upload image
    @user.photo.attach(data: params[:photo], filename: 'avatar.jpg', content_type: 'image/jpg') if params[:photo].present?
  end

  private

  def user_params
    params.permit(:username, :first_name, :last_name, :email, :about)
  end
end
