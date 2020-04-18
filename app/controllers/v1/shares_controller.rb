class V1::SharesController < ApplicationController
  def create
    @share = Share.new(share_params)
    @share.user = @user

    if !@share.save
      return render json: { error: @share.errors.full_messages.first }
    end
  end

  def add_not_signed_in

  end

  private

  def share_params
    params.require(:share).permit(:share_type, :blog_id)
  end
end
