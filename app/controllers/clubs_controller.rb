class ClubsController < ApplicationController

  before_filter   :secure_controller
  
  def index

  end

  def browser
    @id = params[:id]
    if @id
      @category = ClubCategory.find @id
    else
      @category = ClubCategory.root
    end

    if not @category.parent
      render :action => 'browser_root'
    end
  end

  def create
    if params[:club]
      @club = Club.new params[:club]
      @club.active = true
      if @club.save
        group = Group.new
        group.owner = @club
        group.type_id = 5
        group.active = true
        group.name = "Members of #{@club.name}"
        group.save
        group.members << @user
        perm = Permission.new
        perm.active = true
        perm.group = @user.mygroup
        perm.object = @club
        perm.right_id = 1
        perm.granted = true
        perm.save
        redirect_to :controller => 'club', :action => 'index', :id => @club.id
        return
      end
    else
      @club = Club.new
      @club.category_id = params[:id]
    end
  end

end
