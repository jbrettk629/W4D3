class CatsController < ApplicationController
  
  before_action :my_cat?, only: [:edit,:update]
  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    #set user_id to current user's ID
    @cat = Cat.new(cat_params)
    @cat.user_id = current_user.id
    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    @cat = Cat.find(params[:id])
    render :edit
  end

  def update
    @cat = Cat.find(params[:id])
    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end

  private

  def cat_params
    params.require(:cat).permit(:age, :birth_date, :color, :description, :name, :sex)
  end
  # 
  def require_login
    unless logged_in?
      flash[:error] = ["You must be logged out to access this section"]
      redirect_to cats_url
    end
  end
  
  def my_cat?
    #owner owns current cat
    unless @cat.owner.id == current_user.id
      flash[:error] = ["You must own this cat to edit it"]
      redirect_to cats_url
    end
  end
end
