class ProfileController < ApplicationController

  before_filter   :secure_controller
  
  def version   
    return redirect_to(:controller => 'profile', :action => 'report') if not SYSTEM_VERSION > @user.version
    if params[:id] == 'all'
      @versions = @user.version+1 .. SYSTEM_VERSION
    else
      @version = @user.version + 1
      @versions = SYSTEM_VERSION - @user.version
    end
    render :layout => 'public'
  end

  def upgrade
    if not @user.version
      @user.version = 0
      @user.save
    end
    return redirect_to(:controller => 'profile', :action => 'report') if not SYSTEM_VERSION > @user.version
    if params[:id] == 'all'
      ver = @user.version
      versions = @user.version+1 .. SYSTEM_VERSION
      versions.each do |version|
        load "#{RAILS_ROOT}/versions/#{version}.rb"
        _upgrade( @user )
        ver = ver + 1
      end
      @user.version = ver
      @user.save
      return redirect_to(session[:after_upgrade])
    else
      version = @user.version + 1
      load "#{RAILS_ROOT}/versions/#{version}.rb"
      _upgrade( @user )
      @user.version = version
      @user.save
      return redirect_to(session[:after_upgrade])
    end
  end
  
  def report
    @histories  = History.for_user @user
    @requests   = @user.friend_requests
  end

  def status
    @user.change_status(params[:status])
    # Redirect back to profile
    flash[:message] = 'status.changed'
    redirect_to :back
  end

  def index
    ttypes = HistoryType.find(:all)
    @historytypes = []
    pubed =  @user.published_histories
    ttypes.each do |type|
      @historytypes << [type.name, pubed.include?(type.name)]
    end
  end

  def display
    @u = User.find(:first, :conditions => {:id => params[:id], :active => true});
    section = @menu.get_section_by_name 'Profil'
    section.create_action(:action_name => "Profil uživatele #{@u.display}", :controller => :profile, :action => :display, :id => @u.id)
  end

  def friends
    @friends = []
  end

  def public_history
    @user.publish_histories(params[:types])
    redirect_to :back
  end

  def section_add
    
  end
  def section_create
    ps = ProfileSection.new
    ps.title = params[:name]
    ps.type = 'text'
    ps.profile = @user.profile
    ps.save
    redirect_to :action => 'index'
    return
  end
  def section_delete
    ps = ProfileSection.find :first, :conditions => { :id => params[:id] }
    if ps and ps.profile.id == @user.profile.id
      ProfileItem.delete_all("section_id=#{ps.id}")
      ps.delete
    end
    redirect_to :action => 'index'
    return
  end
  def item_create
    pi = ProfileItem.new
    pi.title = params[:name]
    pi.value = params[:value]
    pi.section_id = params[:section]
    pi.save
    redirect_to :action => 'index'
    return
  end
  def item_delete
    ps = ProfileItem.find :first, :conditions => { :id => params[:id] }
    if ps and ps.section.profile.id == @user.profile.id
      ps.delete
    end
    redirect_to :action => 'index'
    return
  end
end
