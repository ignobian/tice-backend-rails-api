class V1::SessionsController < ApplicationController
  def create
    @user = User.find_by(email: session_params[:email])

    if !@user
      return render json: { error: "User with email #{session_params[:email]} not found. Please sign up." }
    end

    if @user&.valid_password?(session_params[:password])
      jwt = JWT.encode(
        { user_id: @user.id, exp: (2.weeks.from_now).to_i },
        ENV['JWT_SECRET'],
        'HS256'
      )

      @token = jwt
    else
      render json: { error: 'Email and password did not match' }, status: :unauthorized
    end
  end
end
