class V1::SessionsController < ApplicationController
  def create
    @user = User.find_by(email: session_params[:email])

    if !@user
      return render json: { error: "User with email #{session_params[:email]} not found. Please sign up." }
    end

    if @user&.valid_password?(session_params[:password])
      jwt = @user.generate_jwt

      @token = jwt
    else
      render json: { error: 'Email and password did not match' }, status: :unauthorized
    end
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
