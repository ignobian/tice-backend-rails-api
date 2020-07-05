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

    # TODO: web socket stuff
    render 'create', status: :created
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end