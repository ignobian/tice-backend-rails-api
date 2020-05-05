class V1::RegistrationsController < ApplicationController
  def pre_signup
    # check if user already exists in the db
    unless User.find_by(email: registration_params[:email]).nil?
      return render json: { error: 'There is already an account with that email' }
    end
    # check if user is valid or not
    @user = User.new(registration_params)
    return render json: { error: @user.errors.full_messages.first } unless @user.valid?

    # transform param has into a hash with symbols
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
  end

  def google_login
    validator = GoogleIDToken::Validator.new
    begin
      payload = validator.check(params[:token_id], ENV["GOOGLE_CLIENT_ID"])
    rescue GoogleIDToken::ValidationError => e
      return render json: { error: "Cannot validate: #{e}" }
    end

    if payload["email_verified"]
      @user = User.find_by(email: payload["email"])
      if @user.nil?
        @user = User.create_with_google(payload)
        @token = @user.generate_jwt
      else

      end
    end
  end

  private

  def registration_params
    params.require(:registration).permit(:username, :first_name, :last_name, :email, :password)
  end
end
