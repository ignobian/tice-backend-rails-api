module ApplicationCable
  class Connection < ActionCable::Connection::Base
    def connect
    end
    # identified_by :current_user

    # def connect
    #   self.current_user = find_verified_user
    # end

    # private

    # def find_verified_user
    #   header = request.headers['Authorization']
    #   header = header.split(' ').last if header

    #   begin
    #     data = JWT.decode(header, ENV['JWT_SECRET'])[0]

    #     verified_user = User.find(data['user_id'])

    #   rescue ActiveRecord::RecordNotFound
    #     return reject_unauthorized_connection

    #   rescue JWT::DecodeError => e
    #     return reject_unauthorized_connection
    #   end

    #   verified_user
    # end
  end
end
