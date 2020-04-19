class AuthorMailer < ApplicationMailer
  def contact
    @from_user = params[:from_user]
    @author = params[:author]
    @message = params[:message]

    mail(to: @author.email, from: @from_user.email, subject: "#{@from_user.name} sent you a message on #{ENV['APP_NAME']}")
  end
end
