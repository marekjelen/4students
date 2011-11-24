class PublicController < ApplicationController

  def index
    @history = History.public
  end

  def signup
  end

  def register
    user = User.create(params[:user])
    if user.save
      user.password = Digest::SHA1.hexdigest(user.password)
      user.save
      Mailer.deliver_registration(user)
      redirect_to :controller => 'public', :action => 'registered'
    else
      flash[:reg_user] = user
      redirect_to :controller => 'public', :action => 'signup'
    end
  end

  def registered
  end

  def confirm
    # Confirm user
    user = User.confirm(params[:id])
    # Check whether user was found   
    return redirect_to(:controller => 'public', :action => 'index') if not user
    # Log user in
    session[:user] = user.id.to_s
    History.add user, nil, 'login.first', {}
    redirect_to :controller => 'profile', :action => 'report'
  end

  def login
    @user = User.authenticate(params[:username], params[:password])
    if @user
      session[:user] = @user.id.to_s
      if params[:remember]
        cookies[:remember_me] = { :value => @user.makecode, :expires => 30.days.from_now }
      else
        cookies[:remember_me] = { :value => @user.makecode }
      end
      History.add @user, nil, 'login.login', {}
      redirect_to :controller => 'profile', :action => 'report'
    else
      session[:user] = nil
      flash[:loginFailed] = true
      redirect_to :controller => 'public'
    end
  end

  def logout
    session[:user] = nil
    cookies[:remember_me] = nil
    if @user
      @user.makecode
    end
    redirect_to :controller => 'public'
  end

end
