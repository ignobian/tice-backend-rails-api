class V1::UsersController < ApplicationController
  before_action :auth_required, except: [:show]

  def index
    @users = User.all
  end

  def show
    # get user from username
    @user = User.find_by(username: params[:username])
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

  def toggle_follower
    @to_be_un_followed = User.find(params[:id])
    # add follower
    if !@to_be_un_followed.followers.where(id: @user.id).empty?
      # remove follower
      Following.where(user: @to_be_un_followed, follower: @user).destroy_all
    else
      # add follower
      Following.create(user: @to_be_un_followed, follower: @user)
    end
    # @user.followings << @to_be_un_followed
  end

  def followers
    @users = @user.followers
  end

  def email_author
    @author = User.find(params[:author_id])
    @message = params[:message]

    AuthorMailer.with(from_user: @user, author: @author, message: @message).contact.deliver_now
  end

  private

  def user_params
    params.permit(:username, :first_name, :last_name, :email, :about)
  end
end
