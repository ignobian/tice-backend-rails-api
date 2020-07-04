class V1::SessionsController < ApplicationController
  def create
    if !Devise.email_regexp.match?(session_params[:email])
      return render json: { error: 'Please enter a valid email' }, status: :bad_request
    end

    @user = User.not_deleted.find_by(email: session_params[:email])

    if !@user
      return render json: { error: "User with email #{session_params[:email]} not found. Please sign up." }, status: :not_found
    end

    if @user&.valid_password?(session_params[:password])
      @token = @user.generate_jwt
    else
      render json: { error: 'Email and password did not match' }, status: :bad_request
    end
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
