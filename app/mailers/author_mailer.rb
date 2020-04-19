class AuthorMailer < ApplicationMailer
  def contact
    @from_user = params[:from_user]
    @author = params[:author]
    @subject = params[:subject]
    @message = params[:message]

    mail(to: @author.email, from: @from_user.email, subject: "#{@from_user.name} on #{ENV['APP_NAME']}: #{@subject}")
  end
end
