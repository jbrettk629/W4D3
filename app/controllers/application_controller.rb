class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?
  before_action :require_login, only: [:new,:create]
  
  def current_user 
    @current_user ||= User.find_by(session_token: session[:session_token])
  end 
  
  def logout!
    current_user.reset_session_token!
    session[:session_token] = nil 
    @current_user = nil
  end 
  
  def login!(user)
    session[:session_token] = user.reset_session_token!
  end 
  
  def logged_in?
    !!current_user
  end 
  
  
  private
  def require_login
    if logged_in?
      flash[:error] = ["You must be logged out to access this section"]
      redirect_to cats_url
    end
  end
end
