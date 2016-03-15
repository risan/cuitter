class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by({ email: params[:session][:email].downcase })
    if user && user.authenticate(params[:session][:password])
      login user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      intended_location_or user
    else
      flash.now[:danger] = "Invalid email and password."
      render :new
    end
  end

  def destroy
    logout if logged_in?
    redirect_to root_path
  end
end
