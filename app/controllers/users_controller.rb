class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :update_action 
  def show
    @user = User.find(params[:id])
  end

  def new
  end

  def edit
    @user = current_user
  end

  def create
  end

  def update
    @user = User.find(current_user.id)
    if @user.update_attributes(params[:user])
      flash[:notice] = 'Profile successfully updated'
      redirect_to root_path
    else
      flash[:alert] = t("something is wrong, please check the details")
      render :edit
    end
  end

  def destroy
  end
  
  private
  
  def update_action
    unless current_user.nil?
      current_user.update_action
    end
  end
end
