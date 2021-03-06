class SessionsController < ApplicationController

  def new
    @title = "Sign in"
  end

  def create
    loggedin = User.authenticate(params[:session][:email],
                                 params[:session][:password])
    if loggedin
      sign_in loggedin
      redirect_to user_path(loggedin)
    else
      flash.now[:error] = "Invalid email/password combination"
      @title = "Sign in"
      render 'new'
    end    
  end

  def destroy
    sign_out 
    redirect_to root_path
  end
end
