class ApplicationController < ActionController::API
  # some helper methods for protecting routes
  # for this action you need to be signed in
  def auth_required
    unless is_auth?
      return render json: { error: 'Not authorized to perform this action'}, status: :unauthorized
    end
  end

  # for this action you need to be admin
  def admin_required
    if !is_auth? || !@user.admin?
      return render json: { error: 'Not authorized to perform this action' }, status: :unauthorized
    end
  end

  private

  def is_auth?
    header = request.headers['Authorization']
    header = header.split(' ').last if header

    begin
      data = JWT.decode(header, ENV['JWT_SECRET'])[0]

      @user = User.find(data['user_id'])
    rescue ActiveRecord::RecordNotFound
      return false
    rescue JWT::DecodeError => e
      return false
    end

    true
  end
end
