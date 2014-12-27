class UsersController < ApplicationController

  before_action :loggedIn, only: [:new,:create,:login]
  before_action :loggedOut, only: [:logout]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "User erfolgreich angelegt."
    else
      flash[:error] = "Es ist ein Fehler aufgetreten!"
    end

    render "new"
  end

  def login

  end

  def authenticate
    user = User.authenticate(params[:username_or_email],params[:login_password])
    if user
      session[:userID] = user.id
      redirect_to root_path
    else
      flash[:error] = "Invalid Username or Password"
      render "login"  
    end
  end

  def logout
    session[:userID] = nil
    redirect_to root_path
  end



private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def loggedIn
    redirect_to root_path unless !session[:userID]
  end

  def loggedOut
    redirect_to root_path unless session[:userID]
  end

end
