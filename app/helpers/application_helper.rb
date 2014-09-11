module ApplicationHelper
  def placeholder_image(options = {})
    options[:size] ||= 50
    options[:category] ||= "abstract"
    "http://lorempixel.com/#{options[:size]}/#{options[:size]}/#{options[:category]}/#{rand(1..10)}"
  end

  def date_in_words
    self ? self.strftime("%b %d, %Y") : false
  end

  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.digest(remember_token))
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def signed_in_user
    unless signed_in?
      flash[:alert] = "Please sign in!"
      redirect_to root_url 
    end
  end

  def sign_out
    current_user.update_attribute(:remember_token,
                                  User.digest(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.digest(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def store_location
    session[:return_to] = request.request_url
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end
