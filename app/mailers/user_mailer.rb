class UserMailer < ApplicationMailer
  NOTHING_TO_CONFIRM = "FAILED EMAIL CHANGE"
  URI_KLASS = ENV["FORCE_SSL"] ? URI::HTTPS : URI::HTTP

  # Make sure the user gave us a valid email.
  def welcome_email(user)
    @user = user
    @user_name = user.name
    @the_url = UserMailer.reset_url(user)
    mail(to: @user.email, subject: "欢迎使用 FarmBot 管理后台")
  end

  def password_reset(user, raw_token)
    @user = user
    url = UserMailer.url_object
    url.path = "/password_reset/#{raw_token}"
    @password_reset_url = url.to_s
    mail(to: @user.email, subject: "FarmBot 密码重置通知")
  end

  # Much like welcome_email, it is used to check email validity.
  # Triggered after the user tries update the `email` attr in Users#update.
  def email_update(user)
    raise NOTHING_TO_CONFIRM unless user.unconfirmed_email.present?
    @user = user
    @the_url = UserMailer.reset_url(user)

    mail(to: @user.unconfirmed_email,
         subject: "FarmBot 邮箱更新通知")
  end

  def self.reset_url(user)
    x = UserMailer.url_object
    x.path = "/verify/#{user.confirmation_token}"
    x.to_s
  end

  def self.url_object(host = ENV.fetch("API_HOST"), port = ENV.fetch("API_PORT"))
    output = {}
    output[:host] = host
    output[:port] = port unless [nil, "443", "80"].include?(port)
    URI_KLASS.build(output)
  end
end
