require 'oauth/helper'

class ApplicationController < ActionController::Base

  include OAuth::Helper

  helper :all # include all helpers, all the time
  protect_from_forgery

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  before_filter :_prepare_controller
  before_filter :_check_user
  before_filter :_development
  before_filter :_menu

  protected

  def _development
    if RAILS_ENV == 'development'
      # These task are performed on every request, but only in development mode     
    end
  end

  def _menu
    @menu = Komunity.create_menu
  end

  def _prepare_controller
    @versioning = true
    @user = nil
  end

  def _login
    # Logged in user using form or remember me
    if session[:user]
      user = User.find(:first, :conditions => { :id => session[:user], :active => true })
      if not user
        session[:user] = nil
      else
        @user = user
      end
    end
  end

  def _remember
    # Remember user from cookies
    remember = cookies[:remember_me]
    remember = params[:remember_me] if not remember
    if ( remember and remember != '' ) and not @user
      user = User.find(:first, :conditions => { :code => remember, :active => true })
      if user
        @user = user
        session[:user] = @user.id.to_s
        History.add @user, nil, 'login.remember', {}
      end
    end
  end

  def _api_key
    # User is logging in using API key
    if params[:api] and not @user
      user = User.find :first, :conditions => { :api => params[:api] }
      if user
        @user = user
        @versioning = false
        History.add @user, nil, 'login.api', {}
      end
    end
  end

  def _basic
    # BASIC HTTP authentication
    if not @user
      authenticate_with_http_basic do |username, password|
        user = User.find :first, :conditions => { :username => username, :password => password, :active => true}
        if user
          @user = user
          @versioning = false
          History.add @user, nil, 'login.basic', {}
        end
        @user != nil
      end
    end
  end

  def _oauth
    if not @user
      data = nil
      data = parse_header(request.headers['HTTP_AUTHORIZATION'] || request.headers['WWW-Authenticate']) if request.headers['HTTP_AUTHORIZATION'] || request.headers['WWW-Authenticate']
      if not data
        data = {}
        params.each do |k,v|
          data[k.to_s] = v
        end
      end
      @access_token = OauthAccessToken.find_by_token_and_active(data['oauth_token'], false)
      if not (@access_token and _oauth_verify(data, @access_token.consumer, @access_token.secret) )
        response.status = 401
        return render(:text => 'Bad request')
      else
        @user = @access_token.user
      end
    end
  end

  def _oauth_verify data, consumer, token = nil
    case data['oauth_signature_method']
      when 'PLAINTEXT'
        return(Base64.decode64(data['oauth_signature']) == "#{token}&#{consumer.secret}")
      when 'HMAC-SHA1'
        options = { }
        options[:consumer_secret] = consumer.secret if consumer
        options[:token_secret] = token if token
        OAuth::Signature.verify(request, options)
      when 'RSA-SHA1'
        response.status = 400
    end
  end

  def _check_user
    _login
    _remember
    _api_key
    _basic
  end

  def _version
    # Check user versions
    if @versioning and @user
      @user.version ||= 0
      if ( SYSTEM_VERSION > @user.version ) and ( request.method == :get ) and
              ( not ( params[:controller] == 'profile' and ( params[:action] == 'version' or params[:action] == 'upgrade' ) ) )
        session[:after_upgrade] = request.path
        return redirect_to(:controller => 'profile', :action => 'version')
      end
    end
  end

  def secure_controller
    return redirect_to(:controller => 'public', :action => 'index') if not @user
    _version
  end

end
