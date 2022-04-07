# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def role_changed
    @user = params[:user]
    @old_role = params[:old_role]
    mail(to: @user.email, subject: 'Your Role Changed')
  end
end
