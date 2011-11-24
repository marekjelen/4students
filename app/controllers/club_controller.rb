class ClubController < ApplicationController

  before_filter   :secure_controller
  before_filter   :_club
  before_filter   :_menux
  before_filter   :_security, :except => [ :signin, :signout, :join ]
  before_filter   :_manager
  
  def _club
    @club = Club.find :first, :conditions => { :id => params[:club] }
    if not @club
      redirect_to :controller => 'clubs'
      return
    end
  end

  def _menux
    @section = @menu.create_section(:section_name => 'Klub', :controller => :club, :action => :index)
    @section.create_action(:action_name => 'Přehled', :controller => :club, :action => :index, :id => @club.id)
    @section.create_action(:action_name => 'Členové', :controller => :club, :action => :members, :id => @club.id)
  end
 
  def _security
    @member = @club.member?(@user)
    if ( not @member )
      if ( not @club.visible ) or ( @club.locked and not @club.public)
        redirect_to :controller => 'clubs'
        return
      end
      if ( @club.locked and @club.public or not @club.locked and not @club.public )
        redirect_to :controller => 'club', :action => 'signin', :id => @club.id
        return
      end
    end
  end
  
  def _manager
    p = Permission.find :first, :conditions => {
      :group_id => @user.mygroup.id,
      :object_id => @club.id,
      :object_type => 'Club',
      :right_id => 1,
      :active => true
    }
    if p
      @manager = true
      @section.create_action(:action_name => 'Pozvat člena', :controller => :club, :action => :invite, :id => @club.id)
    end
  end

  def index
    @messages = ClubMessage.find :all, :conditions => { :user_id => @user.id, :club_id => @club.id }, :order => 'created_at DESC'
  end

  def message
    msg = ClubMessage.new 
    msg.user = @user
    msg.message = params[:message][:message]
    msg.club = @club
    msg.save
    redirect_to :controller => 'club', :action => 'index', :id => msg.club_id
    return
  end

  def signin
    @section.create_action(:action_name => 'Přihlásit do klubu', :controller => :club, :action => :signin, :id => @club.id)
  end

  def join
    ms = Membership.find :first, :conditions => {
      :group_id => @club.group.id,
      :user_id => @user.id,
    }
    if not ms
      ms = Membership.new
      ms.group = @club.group
      ms.user = @user
    end
    if not @club.locked and not @club.public
      ms.active = false
      ms.invitation = false
      ms.save
      redirect_to :controller => 'clubs'
      return
    end
    if ( not @club.locked and @club.public ) or ( ms.invitation )
      ms.active = true
      ms.save
      redirect_to :controller => 'club', :action => 'index', :id => @club.id
      return
    end
    redirect_to :controller => 'clubs'
  end

  def signout
    @club.member! @user
    if @club.visible and @club.public and not @club.locked
      redirect_to :controller => 'club', :action => 'index', :id => @club.id
      return
    else
      redirect_to :controller => 'clubs', :action => 'index'
      return
    end
  end

  def members
    @members = @club.allmembers
  end

  def invite
    if not @manager
      redirect_to :action => 'index', :id => @club.id
      return
    end
    if params[:member]
      @mem = User.find :first, :conditions => {
        :username => params[:member]
      }
      if @mem
        ms = Membership.find :first, :conditions => {
          :group_id => @club.group.id,
          :user_id => @mem.id,
        }
        if not ms
          ms = Membership.new
          ms.group = @club.group
          ms.user = @mem
          ms.active = false
          ms.invitation = true
          ms.save
        else
          @exists = true
        end
      end
    end
  end

end
