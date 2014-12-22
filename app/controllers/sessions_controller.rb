class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # log in and redirect
      log_in(user)
      # Remember user if checkbox is marked
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to(user)   # rails infers and converts this to redirect_to(user_path(user))
    else
      # show error
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
