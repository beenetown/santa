require 'development_mail_interceptor'

ActionMailer::Base.smtp_settings = {
  :address                => "smtp.gmail.com",
  :port                   => 587,
  :domain                 => "www.gmail.com",
  :user_name              => ENV["GMAIL_USERNAME"],
  :password               => ENV["GMAIL_PASSWORD"],
  :authentication         => "plain",
  :enable_starttls_auto   => true
}

ActionMailer::Base.default_url_options[:host] = Rails.env.production? ? "santamatic.in" : "localhost:3000"

ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?