# frozen_string_literal: true

class PasswordMailer < ApplicationMailer
  def edit_password_email
    @token = params['authenticity_token']
    # raise params['authenticity_token']
    # @email = params['email']
    mail(to: 'spanasuriya892@rku.ac.in', subject: 'Password Token')
  end

  def new_cridential_mail
    @user = params[:user]
    @password = params[:password]
    mail(to: @user.email, subject: 'Login cridential')
  end
end
