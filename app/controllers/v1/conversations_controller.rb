class V1::ConversationsController < ApplicationController
  before_action :auth_required

  def find
    @conversation_user = User.find(params[:with])
    @conversation = @user.conversations.joins(:users).find_by(users: { id: @conversation_user.id })

    if @conversation.nil?
      # create a new conversation with the 2 users
      @conversation = Conversation.create(users: [@conversation_user, @user])
    end

    return render json: { id: @conversation.id }
  end
end
