class UsersController < ApplicationController

  before_action :loggedIn, only: [:add_route]
  before_action :loggedOut, only: [:new,:create,:login]

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
      redirect_to :action => "dashboard"
    else
      flash[:error] = "Benutzername oder Passwort falsch"
      render "login"  
    end
  end

  def dashboard
    @user = User.find(session[:userID])
  end

  def logout
    session[:userID] = nil
    redirect_to root_path
  end

  def add_route
    
    @user = User.find(session[:userID])
    @route = Route.find(params[:id]) if Route.exists?(params[:id])

    if(@route == nil)
      flash[:error] = "Diese Route konnte nicht gefunden werden."
    elsif(@user.routes.exists?(params[:id]))
      flash[:error] = "Diese Route hast du bereits hinzugefügt!"
    else
      @user.routes.push(@route)
      flash[:success] = "Route erfolgreich hinzugefügt!"
    end

    render 'dashboard'

  end

  def remove_route

    @user = User.find(session[:userID])
    @route = Route.find(params[:id]) if Route.exists?(params[:id])

    if(@route == nil)
      flash[:error] = "Diese Route konnte nicht gefunden werden."
    elsif(!@user.routes.exists?(params[:id]))
      flash[:error] = "Diese Route ist nicht mit deinem Profil verknüpft!"
    else
      @user.routes.delete(@route)
      flash[:success] = "Route erfolgreich entfernt."
    end

    render 'dashboard'

  end

private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def loggedIn
    flash[:error] = "Du musst eingeloggt sein, um diese Aktion ausführen zu können"
    redirect_to root_path unless session[:userID]
  end

  def loggedOut
    redirect_to root_path unless !session[:userID]
  end

end
