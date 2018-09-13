class SessionsController < ApplicationController
  def new
    @user = User.new
    render :new
  end
  
  def create
    @user = User.find_by_credentials(
                params[:user][:username],
                params[:user][:password])
    if @user
      login!(@user)
      redirect_to cats_url
    else
      flash.now[:errors] = ['Invalid Login Credentials']
      render :new
    end
  end  
  
  def destroy
    user = current_user
    if user
      user.reset_session_token!
    end
    session[:session_token] = nil
    # logout! 
    redirect_to cats_url
  end 
  
  
  
  
end