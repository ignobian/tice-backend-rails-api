class UserMailer < ApplicationMailer
  default from: ENV['EMAIL_FROM']
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #
  def welcome
    @user = params[:user]
    mail(to: @user.email, subject: 'Welcome to Ignob')
  end

  def signup_activation
    @activation_url = "#{ENV['CLIENT_URL']}/user/activate/#{params[:token]}"
    @user = params[:user]
    mail(to: @user[:email], subject: 'Activate your account on Ignob')
  end

  def forgot_password
    @user = params[:user]
    @reset_url = "#{ENV['CLIENT_URL']}/password/reset/#{params[:token]}"
    mail(to: @user.email, subject: 'Reset your password for Ignob')
  end
end
