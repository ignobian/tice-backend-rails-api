class V1::MessagesController < ApplicationController
  before_action :auth_required

  def index
    # fetch most recent messages, skipping the skip params
    @conversation = @user.conversations.find(params[:conversation_id])
    @skip = params[:skip].to_i
    @messages = @conversation.messages.includes(:user).order(created_at: :desc).offset(@skip).limit(10).reverse
  end

  def create
    # find conversation
    @conversation = @user.conversations.find(params[:conversation_id])

    @message = @conversation.messages.build(message_params)
    @message.user = @user

    if !@message.save
      return render json: { error: @message.errors.full_messages.first }, status: :bad_request
    end

    # web socket stuff
    ConversationChannel.broadcast_to(@conversation, @message.json_hash)

    render 'create', status: :created
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
