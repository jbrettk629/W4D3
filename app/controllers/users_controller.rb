class UsersController < ApplicationController
  
  def new
    @user = User.new 
    render :new
  end 
  
  def create 
    @user = User.new(params)
    
    if @user.save!
      login!(@user) 
         redirect_to user_url(@user) 
    else 
      flash[:errors] = @user.errors.full_messages
      render new_user_url
    end
  end 
  
  
  
  
  
  
end 