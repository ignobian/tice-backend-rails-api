class ConversationChannel < ApplicationCable::Channel
  def subscribed
    # verify user
    user_id = JWT.decode(params[:token], ENV['JWT_SECRET'])[0]["user_id"]

    conversation = Conversation.find(params[:id])

    unless conversation.users.find(user_id).nil?
      stream_for conversation
    end
  end
end
