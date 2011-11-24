require 'base64'
require 'oauth/request_proxy/action_controller_request'

#module Komunity
#  mattr_accessor :rt
#end

class OauthController < ApplicationController

  def index
  end

  def meta

  end

  def request_token
    # Parse request
    data = nil
    data = parse_header(request.headers['HTTP_AUTHORIZATION'] || request.headers['WWW-Authenticate']) if request.headers['HTTP_AUTHORIZATION'] || request.headers['WWW-Authenticate']
    if not data
      data = {}
      params.each do |k,v|
        data[k.to_s] = v
      end
    end
    # Validate consumer
    consumer = OauthConsumer.find_by_key(data['oauth_consumer_key'])
    if consumer and _oauth_verify(data, consumer)
      # Generate request tokens
      headers['Content-type'] = 'application/x-www-form-urlencoded'
      rt = OauthRequestToken.create(:token => generate_key(16), :secret => generate_key, :request => Marshal.dump(data))
      rt.save
      render :text => "oauth_token=#{rt.token}&oauth_token_secret=#{rt.secret}&oauth_callback_confirmed=true"
    else
      # Invalid consumer
      response.status = 401
      render :text => 'Bad request'
    end
  end

  def authorize
    # Validate request token
    @token = OauthRequestToken.find_by_token(params[:oauth_token])
    return redirect_to(:controller => 'public') if not @token
    if @user
      @token.user = @user.id
      @token.save
      return redirect_to(:controller => :oauth, :action => :authorize3, :oauth_token => params[:oauth_token], :oauth_callback => params[:oauth_callback])
    end
    return render(:action => :authorize, :layout => false)
  end

  def authorize2
    # Validate user
    user = User.find_by_username_and_password_and_active(params[:username], params[:password], true)
    return redirect_to(:controller => :oauth, :action => :authorize, :oauth_token => params[:oauth_token], :oauth_callback => params[:oauth_callback], :loginFailed => 'yes') if not user
    # Validate token
    @token = OauthRequestToken.find_by_token(params[:oauth_token])
    return redirect_to(:controller => 'public') if not @token
    # Connect user and token
    @token.user = user.id
    @token.save
    return redirect_to(:controller => :oauth, :action => :authorize3, :oauth_token => params[:oauth_token], :oauth_callback => params[:oauth_callback])
  end

  def authorize3
    # Check token
    @token = OauthRequestToken.find_by_token(params[:oauth_token])
    return redirect_to(params[:oauth_callback]) if not @token
    # Load information
    @request = Marshal.restore(@token.request)
    @consumer = OauthConsumer.find_by_key(@request['oauth_consumer_key'])
    # Validate user
    return redirect_to(:controller => :oauth, :action => :authorize, :oauth_token => params[:oauth_token], :oauth_callback => params[:oauth_callback], :loginFailed => 'yes') if not @token.user
    @user = User.find(@token.user)
    return redirect_to(:controller => :oauth, :action => :authorize, :oauth_token => params[:oauth_token], :oauth_callback => params[:oauth_callback], :loginFailed => 'yes') if not @user
    return render(:action => :authorize3, :layout => false)
  end

  def authorize4
    # Check token
    @token = OauthRequestToken.find_by_token(params[:oauth_token])
    return redirect_to(:controller => 'public') if not @token
    # Deny access
    if params[:type] == 'deny'
      @token.delete
      return redirect_to(params[:oauth_callback])
    end
    # Load information
    @request = Marshal.restore(@token.request)
    @consumer = OauthConsumer.find_by_key(@request['oauth_consumer_key'])
    @user = User.find(@token.user)
    # Prepare access tokens
    @access = OauthAccessToken.new
    @access.active = false
    @access.request_token = @token.token
    @access.user = @user
    @access.consumer = @consumer
    @access.token = generate_key(16)
    @access.secret = generate_key
    @access.verifier = generate_key
    # Allow access
    if params[:type] == 'remember'
      # Permanent authorization
    elsif params[:type] == 'allow'
      # Temporary authorization
      @access.expire = 120.minutes.from_now
    end
    # Save inactive access token
    @access.save
    # If OOB, then render text instead of callback
    if @request['oauth_callback'] == 'oob' and not params[:oauth_callback]
      headers['Content-type'] = 'application/x-www-form-urlencoded'
      return render(:text => "oauth_token=#{@token.token}&oauth_verifier=#{@access.verifier}")
    end
    # Generate URL
    url = URI.parse(@request['oauth_callback'] || params[:oauth_callback])
    append = "oauth_token=#{@token.token}&oauth_verifier=#{@access.verifier}"
    if url.query
      url.query += "&#{append}"
    else
      url.query = append
    end
    # Redirect user back
    return redirect_to(url.to_s)
  end

  def access_token
    # Parse request
    data = nil
    data = parse_header(request.headers['HTTP_AUTHORIZATION'] || request.headers['WWW-Authenticate']) if request.headers['HTTP_AUTHORIZATION'] || request.headers['WWW-Authenticate']
    if not data
      data = {}
      params.each do |k,v|
        data[k.to_s] = v
      end
    end
    # Load information
    @consumer = OauthConsumer.find_by_key(data['oauth_consumer_key'])
    @token = OauthRequestToken.find_by_token(data['oauth_token'])
    @access = OauthAccessToken.find_by_request_token_and_verifier_and_active(data['oauth_token'], data['oauth_verifier'], false)
    # Check validity of data
    if @token and @access and @consumer and ( @access.consumer == @consumer ) and _oauth_verify(data, @consumer, @token.secret)
      # Activate access token
      token.delete
      access.active = true
      access.save
      # Render access token information
      headers['Content-type'] = 'application/x-www-form-urlencoded'
      return render(:text => "oauth_token=#{@access.token}&oauth_token_secret=#{@access.secret}")
    else
      # Invalid request
      response.status = 401
      return render(:text => 'Bad request')
    end
  end

end
