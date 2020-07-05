class V1::MessagesController < ApplicationController
  before_action :auth_required

  def create
    # find conversation
    @conversation = @user.conversations.find(params[:conversation_id])

    @message = @conversation.messages.build(message_params)
    @message.user = @user

    if !@message.save
      return render json: { error: @message.errors.full_messages.first }, status: :bad_request
    end

    # web socket stuff
    ConversationChannel.broadcast_to(@conversation, { message: @message.content }.to_json)

    render 'create', status: :created
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
