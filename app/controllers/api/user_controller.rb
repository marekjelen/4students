class Api::UserController < ApplicationController
  layout false
  def index
    render :text => 'Interacts with logged-in user information.'
  end

  def info
    publish = {
            :id => @user.id,
            :username => @user.username,
            :created => @user.created_at,
            :updated => @user.updated_at,
            :display => @user.display,
            :name => @user.name,
            :surname => @user.surname,
            :status => @user.status
    }
    render :text => publish.to_json
  end

  def avatar
    render :text => @user.avatar_url(:size => params[:id])
  end

  def email
    
  end

end
