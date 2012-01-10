class UsersController < ApplicationController

  def show
    @user = User.find_by_id(params[:id])
    @title = @user.name
  end


  def new
    @title = "Sign up"
  end



end
