# Preview all emails at http://localhost:3000/rails/mailers/password_mailer
class PasswordMailerPreview < ActionMailer::Preview
    # order = Order.new(name: "Joe Smith", email: "joe@gmail.com", address: "1-2-3 Chuo, Tokyo, 333-0000", phone: "090-7777-8888", message: "I want to place an order!")
    def edit_password_email
        PasswordMailer.with(authenticity_token: 'xyz', mail: "spanasuriya892@rku.ac.in").edit_password_email
    end
end
