class FriendsController < ApplicationController

  before_filter   :secure_controller

  # Search for friends
  def search
    @users = []
  end
  
  def add
    # Find user
    friend = User.find(:first, :conditions => {:username => params[:id], :active => true})
    if friend == nil
      # User not found
      flash[:message] = 'friendships.not_found'
      flash[:icon] = 'error'
      return redirect_to(:controller => "profile", :action => "friends")
    elsif @user.id == friend.id
      # Befriending yourself
      flash[:message] = 'friendships.yourself'
      flash[:icon] = 'error'
      return redirect_to(:controller => "profile", :action => "friends")
    end
    # You are requested friendship from user
    sql = "
        SELECT `memberships`.*
          FROM `memberships`
          JOIN `groups`
            ON `memberships`.`group_id` = `groups`.`id`
          WHERE `memberships`.`user_id` = #{friend.id}
            AND `groups`.`type_id` = 4 AND `groups`.`owner_id` = #{@user.id}
            AND `groups`.`owner_type` = 'User'
          ORDER BY `memberships`.`created_at` DESC
    "
    m = Membership.find_by_sql(sql)
    # User has already join with you
    if m.length > 0
      m = m[0]
      # Not accepted => accept
      if not m.active
        return redirect_to(:controller => 'friends', :action => 'accept', :id => friend.username)
      end
      # Accepted => already friends => error
      if m.active
        flash[:message] = 'friendships.exists'
        flash[:icon] = 'error'
        return redirect_to(:controller => "profile", :action => "friends")
      end
    end
    # Create new friendship
    group = Group.find(:first, :conditions => { :owner_type => 'User', :owner_id => friend.id, :type_id => 4 })
    friendship = Membership.new
    friendship.group = group
    friendship.user = @user
    friendship.active = false
    friendship.save
    # Redirect back
    flash[:message] = 'friendships.requested'
    redirect_to(:controller => "profile", :action => "friends")
  end

  def accept
    # Find friend
    friend = User.find(:first, :conditions => {:username => params[:id], :active => true})
    if not friend
      flash[:message] = 'friendships.not_found'
      flash[:icon] = 'error'
      return redirect_to(:controller => "profile", :action => "friends")
    end
    # Locate friendship request
    sql = "
          SELECT `memberships`.*
            FROM `memberships`
            JOIN `groups`
              ON `memberships`.`group_id` = `groups`.`id`
            WHERE `memberships`.`user_id` = ? AND `memberships`.`active` = ?
              AND `groups`.`type_id` = ? AND `groups`.`owner_id` = ?
              AND `groups`.`owner_type` = ?
            ORDER BY `memberships`.`created_at` DESC
    "
    friendship = Membership.find_by_sql([ sql, friend.id, false, 4, @user.id, 'User' ])
    if friendship.length == 0
      flash[:message] = 'friendships.request_not_found'
      flash[:icon] = 'error'
      return redirect_to(:controller => "profile", :action => "friends")
    else
      friendship = friendship[0]
    end
    friendship.active = true
    friendship.save
    # Create friendship binding
    group = Group.find(:first, :conditions => { :owner_type => 'User', :owner_id => friend.id, :type_id => 4 })
    friendship2 = Membership.new
    friendship2.group = group
    friendship2.user = @user
    friendship2.active = true
    friendship2.save
    # Create history items
    History.add @user, friend, 'friendships.new', { :friend => friend.display, :id => friend.id }
    History.add friend, @user, 'friendships.new', { :friend => @user.display, :id => @user.id }
    # Redirect back
    flash[:message] = 'friendships.accepted'
    redirect_to(:controller => "profile", :action => "report")
  end

  def reject
    # Find friend
    friend = User.find(:first, :conditions => {:username => params[:id], :active => true})
    if not friend
      flash[:message] = 'friendships.not_found'
      flash[:icon] = 'error'
      return redirect_to(:controller => "profile", :action => "friends")
    end
    # Locate friendship request
    sql = "
          SELECT `memberships`.*
            FROM `memberships`
            JOIN `groups`
              ON `memberships`.`group_id` = `groups`.`id`
            WHERE `memberships`.`user_id` = #{friend.id} AND `memberships`.`active` = 0
              AND `groups`.`type_id` = 4 AND `groups`.`owner_id` = #{@user.id}
              AND `groups`.`owner_type` = 'User'
            ORDER BY `memberships`.`created_at` DESC
    "
    friendship = Membership.find_by_sql(sql)
    if friendship.length == 0
      flash[:message] = 'friendships.request_not_found'
      flash[:icon] = 'error'
      return redirect_to(:controller => "profile", :action => "friends")
    else
      friendship = friendship[0]
    end
    friendship.delete
    # Redirect back
    flash[:message] = 'friendships.rejected'
    redirect_to(:controller => "profile", :action => "report")
  end

  def cancle
    # Find user
    friend = User.find(:first, :conditions => {:username => params[:id], :active => true})
    if not friend
      flash[:message] = 'friendships.not_found'
      flash[:icon] = 'error'
      return redirect_to(:controller => "profile", :action => "friends")
    end
    # Find
    sql = "
            SELECT `memberships`.*
              FROM `memberships`
              JOIN `groups`
                ON `memberships`.`group_id` = `groups`.`id`
              WHERE `memberships`.`user_id` = #{@user.id}
                AND `groups`.`type_id` = 4 AND `groups`.`owner_id` = #{friend.id}
                AND `groups`.`owner_type` = 'User'
              ORDER BY `memberships`.`created_at` DESC
    "
    f2 = Membership.find_by_sql(sql)
    sql = "
            SELECT `memberships`.*
              FROM `memberships`
              JOIN `groups`
                ON `memberships`.`group_id` = `groups`.`id`
              WHERE `memberships`.`user_id` = #{friend.id}
                AND `groups`.`type_id` = 4 AND `groups`.`owner_id` = #{@user.id}
                AND `groups`.`owner_type` = 'User'
              ORDER BY `memberships`.`created_at` DESC
    "
    f1 = Membership.find_by_sql(sql)
    # Check
    if f2.length == 0
      flash[:message] = 'friendships.not_found'
      flash[:icon] = 'error'
      return redirect_to(:controller => "profile", :action => "friends")
    else
      f2 = f2[0]
    end
    # Delete
    if f1.length == 0
      f2.delete
      flash[:message] = 'friendships.request_cancled'
    else
      f1 = f1[0]
      f2.delete
      f1.delete
      flash[:message] = 'friendships.cancled'
    end
    # Return
    return redirect_to(:controller => "profile", :action => "friends")
  end

end 