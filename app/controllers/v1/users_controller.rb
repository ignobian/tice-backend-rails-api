class V1::UsersController < ApplicationController
  before_action :auth_required

  def edit
  end

  def update
    if !@user.update(user_params)
      return render json: { error: @user.errors.full_messages.first }
    end
  end

  private

  def user_params
    params.permit(:username, :first_name, :last_name, :email, :about)
  end
end
