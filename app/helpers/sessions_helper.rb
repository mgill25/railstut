module SessionsHelper
  def log_in(user)
    # Only temporary cookies are secure, permanent cookies
    # are vulnerable to session hijacking.
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end
end
