class ConversationChannel < ApplicationCable::Channel
  def subscribed
    conversation = Conversation.find_by(params[:id])
    stream_for conversation
  end
end
