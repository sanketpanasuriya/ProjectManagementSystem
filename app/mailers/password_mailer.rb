class PasswordMailer < ApplicationMailer
    def edit_password_email
        @token=params['authenticity_token']
        # raise params['authenticity_token']
        # @email = params['email']
        mail(to: "spanasuriya892@rku.ac.in", subject: "Password Token")
    end
end
