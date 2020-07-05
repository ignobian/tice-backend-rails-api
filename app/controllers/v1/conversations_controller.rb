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

  def show
    @conversation = @user.conversations.find_by_id(params[:id])

    if @conversation.nil?
      return render json: { error: 'Not found' }, status: :not_found
    end

    # find the other user that is part of the conversation
    @conversation_user = @conversation.users.where.not(id: @user.id).first
    @last_seen = @conversation_user.last_seen(@conversation)
    @messages = @conversation.messages.includes(:user)
  end
end
