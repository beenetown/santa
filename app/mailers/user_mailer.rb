class UserMailer < ActionMailer::Base
  default from: "john@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.signup_confirmation.subject
  #
  def signup_confirmation(user)
    @user = user
    mail to: user.email, subject: "Welcome"
  end

  def invite_to_group(email, group, user)
    @email = email
    @group = group
    @user = user
    mail to: email, subject: "Secret Santa Group"
  end

  def invite_new_user(email, group, user, password)
    @email = email
    @group = group
    @user = user
    @password = password

    mail to: email, subject: "#{group.owner.view_name} invited you to a Secret Santa group!"  end
end
