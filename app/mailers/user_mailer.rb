class UserMailer < ActionMailer::Base
    default from: "forsakenworldvampire@gmail.com"
    
    def forgot_password(user)
        @user = user
        mail(:to => user.email, :subject => "Request for a password reset", :template_name => "forgot_password")
    end
    
    def send_new_password(user, password)
        @password = password
        mail(:to => user.email, :subject => "Reset password", :template_name => "send_new_password")
    end
end
