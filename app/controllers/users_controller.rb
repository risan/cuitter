class UsersController < ApplicationController
  before_action :must_be_logged_in, only: [:index, :edit, :update, :destroy]
  before_action :must_be_correct_user, only: [:edit, :update]
  before_action :must_be_admin, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login @user
      flash[:success] = "Welcome to Cuitter #{@user.name}!"
      redirect_to @user
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def must_be_logged_in
      unless logged_in?
        store_intended_location
        flash[:danger] = "Please login first."
        redirect_to login_url
      end
    end

    def must_be_admin
      redirect_to root_url unless current_user.admin?
    end

    def must_be_correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
