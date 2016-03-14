class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by({ email: params[:session][:email].downcase })
    if user && user.authenticate(params[:session][:password])
      # Log the user in.
    else
      flash[:danger] = "Invalid email and password."
      render :new
    end
  end

  def destroy
  end
end
