class V1::UsersController < ApplicationController
  before_action :auth_required, except: [:show, :populate_sample_data]

  def index
    @users = User.all
  end

  def show
    # get user from username
    @users = User.where(username: params[:username])
    # if we have multiple, then show the one that is not deleted (should be only 1)
    if @users.find_by(is_deleted: false).nil?
      @user = @users.first
    else
      @user = @users.find_by(is_deleted: false)
    end
  end

  def edit
  end

  def update
    if !@user.update(user_params)
      return render json: { error: @user.errors.full_messages.first }, status: :bad_request
    end

    # upload image
    if params[:photo]
      @user.photo.attach(data: params[:photo], filename: 'avatar.jpg', content_type: 'image/jpg') if params[:photo].present?
    end
  end

  def toggle_follower
    @to_be_un_followed = User.find(params[:id])
    # add follower
    if !@to_be_un_followed.real_followers.where(id: @user.id).empty?
      # remove follower
      Following.where(user: @to_be_un_followed, follower: @user).destroy_all
    else
      # add follower
      Following.create(user: @to_be_un_followed, follower: @user)
    end
    # @user.followings << @to_be_un_followed
  end

  def stats
  end

  def followers
    @users = @user.real_followers
  end

  def email_author
    @author = User.find(params[:author_id])
    @message = params[:message]

    AuthorMailer.with(from_user: @user, author: @author, message: @message).contact.deliver_now
  end

  def populate_sample_data
    pwd = 'testing'

    # Free plan user
    admin = User.new(
      first_name: 'Mr', 
      last_name: 'Admin', 
      username: 'awesomeadmin', 
      password: pwd, 
      password_confirmation: pwd, 
      email: 'admin@ignob.com', 
      role: 1
    )
    admin.save!

    blog1 = Blog.new(
      title: 'A new blog post about nextjs and the awesome works of next',
      slug: 'sample-blog-post-next',
      body: '<p>Sample content...</p>',
      user: admin
    )
    blog1.save!

    user = User.new(
      first_name: 'Mr', 
      last_name: 'User', 
      username: 'awesomeman', 
      password: pwd, 
      password_confirmation: pwd, 
      email: 'user@ignob.com', 
      role: 0
    )
    user.save!

    blog2 = Blog.new(
      title: 'A new blog post about reactjs and the awesome works of react',
      slug: 'sample-blog-post-react',
      body: '<p>Sample content...</p>',
      user: user
    )
    blog2.save!

    render json: {
      message: "Sample data generated successfully!",
      users_count: User.count,
      blogs_count: Blog.count
    }, status: :created
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def user_params
    params.permit(:username, :first_name, :last_name, :email, :about)
  end
end
