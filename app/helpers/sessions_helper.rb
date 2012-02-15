module SessionsHelper

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    current_user = user #self.current_user = user
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    # @current_user is nil then call user_from_remember_token,
    # if it's not nil, then just return @current_user
    @current_user ||= user_from_remember_token
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def sign_out
    cookies.delete(:remember_token)
    current_user = nil #self.current_user
  end
  
  def deny_access
    store_location
    flash[:notice] = "Please sign in before accessing this page."
    redirect_to signin_path
  end
  
  def store_location
    # session[:hash] expires by then end of browser session
    # just treat it like a hash
    session[:requested_page] = request.fullpath 
  end
  
  def redirect_to_or default
    redirect_to session[:requested_page] || default
    clear_requested_page
  end
  
  def clear_requested_page
    session[:requested_page] = nil
  end

  private
  
  def user_from_remember_token
    User.authenticate_with_salt(*remember_token)
  end
  
  def remember_token
    cookies.signed[:remember_token] || [nil, nil]
  end
end
