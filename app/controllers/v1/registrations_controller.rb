class V1::RegistrationsController < ApplicationController
  before_action :auth_required, only: [:delete_profile]

  def pre_signup
    # check if user already exists in the db
    if !User.not_deleted.find_by(email: registration_params[:email]).nil?
      return render json: { error: 'There is already an account with that email' }, status: :bad_request
    end

    # check if user is valid or not
    @user = User.new(registration_params)
    unless @user.valid?
      return render json: { error: @user.errors.full_messages.first }, status: :bad_request
    end

    # transform param hash into a hash with symbols
    hash = {
      username: registration_params[:username],
      first_name: registration_params[:first_name],
      last_name: registration_params[:last_name],
      email: registration_params[:email],
      password: registration_params[:password]
    }

    # email for response
    @email = registration_params[:email]

    # store the information in a jwt token
    jwt = JWT.encode({ user: hash, exp: 20.minutes.from_now.to_i }, ENV['JWT_ACCOUNT_ACTIVATION'], 'HS256')

    # send an email to the user with the url for account activation
    UserMailer.with(user: hash, token: jwt).signup_activation.deliver_now
  end

  def create
    begin
      user_hash = JWT.decode(params[:token], ENV['JWT_ACCOUNT_ACTIVATION']).first['user']
    rescue JWT::ExpiredSignature
      return render json: { error: 'Expired link, please sign up again' }, status: :bad_request
    end

    @user = User.new(user_hash)

    unless @user.save
      return render json: { error: @user.errors.full_messages.first }, status: :bad_request
    end

    render 'create', status: :created
  end

  def google_login
    validator = GoogleIDToken::Validator.new
    begin
      payload = validator.check(params[:token_id], ENV["GOOGLE_CLIENT_ID"])
    rescue GoogleIDToken::ValidationError => e
      return render json: { error: "Cannot validate: #{e}" }
    end

    if payload["email_verified"]
      @user = User.not_deleted.find_by(email: payload["email"])

      if @user.nil?
        @user = User.create_with_google(payload)
      end

      @token = @user.generate_jwt
    else
      return render json: { error: "Cannot validate: #{params[:email]}" }
    end
  end

  def facebook_login
    payload = User.get_info_from_facebook_access_token(params.permit(:access_token)[:access_token])
    if payload["email"]
      @user = User.not_deleted.find_by(email: payload["email"])
      if @user.nil?
        @user = User.create_with_facebook(payload)
      end

      @token = @user.generate_jwt
    else
      return render json: { error: "Cannot validate user" }
    end
  end

  def forgot_password
    # find user with submitted email
    @user = User.not_deleted.find_by(email: params[:email])
    return render json: { error: 'User with that email not found, please sign up' } if @user.nil?

    # make a jwt with user id
    jwt = JWT.encode({ user_id: @user.id, exp: 30.minutes.from_now.to_i }, ENV['JWT_RESET_PASSWORD'], 'HS256')

    # send an email with password reset link to the user
    UserMailer.with(user: @user, token: jwt).forgot_password.deliver_now
  end

  def reset_password
    begin
      decoded = JWT.decode(params[:token], ENV['JWT_RESET_PASSWORD']).first
    rescue JWT::ExpiredSignature
      render json: { error: 'The link has expired, please resend link' }
      return
    end

    new_password = params[:new_password]
    # password length check
    return render json: { error: 'Password has to be at least 7 characters long' } if new_password.length < 7

    # find our user
    @user = User.find(decoded['user_id'])

    # update the user
    @user.update!(password: new_password)
  end

  def delete_profile
    @user.update(is_deleted: true)
    if params[:also_delete_blogs]
      @user.blogs.destroy_all
    end
  end

  private

  def registration_params
    params.require(:registration).permit(:username, :first_name, :last_name, :email, :password)
  end
end
