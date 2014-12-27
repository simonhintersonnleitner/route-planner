module ApplicationHelper

  def isLoggedIn()
    if session[:userID]
      return true
    else
      return false
    end
  end

end
