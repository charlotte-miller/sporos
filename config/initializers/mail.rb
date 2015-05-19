if Rails.env.production?
  ActionMailer::Base.smtp_settings = {
    address: 'smtp.mandrillapp.com',
    port: 587,
    enable_starttls_auto:true,
    user_name: AppConfig.mail.smtp_user,
    password:  AppConfig.mail.smtp_pass,
    authentication: 'login'
  }
end

ActionMailer::Base.delivery_method = AppConfig.mail.delivery_method
ActionMailer::Base.default charset: "utf-8"