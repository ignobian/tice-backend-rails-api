class ApplicationController < ActionController::API
  # some helper methods for protecting routes
  # for this action you need to be signed in
  def auth_required
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      data = JWT.decode(header, ENV['JWT_SECRET'])[0]

      @user = User.not_deleted.find(data['user_id'])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Not authorized to perform this action' }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { error: 'Not authorized to perform this action' }, status: :unauthorized
    end
  end

  # for this action you need to be admin
  def admin_required
    auth_required

    unless @user.admin?
      render json: { error: 'Admin resource, access denied' }, status: :unauthorized
    end
  end
end
