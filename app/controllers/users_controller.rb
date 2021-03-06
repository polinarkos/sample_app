class UsersController < ApplicationController

  def show
    @user = User.find_by_id(params[:id])
    @title = @user.name
  end


  def new
    @user = User.new
    @title = "Sign up"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the sample app"
      redirect_to @user   #user_path(@user)
    else
      @title = "Sign up"
      render 'new'
    end
  end

end
