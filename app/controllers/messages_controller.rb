require 'json'

class MessagesController < ApplicationController

  before_filter   :secure_controller
  
  def index
    if params[:id]
      @folder = MailFolder.find(params[:id])
    else
      @folder = MailFolder.find(:first, :conditions => { :user_id => @user, :type => 'inbox' })
      if not @folder
        @folder = MailFolder.new
        @folder.title = 'Doručená pošta'
        @folder.user = @user
        @folder.type = 'inbox'
        @folder.save
        folder = MailFolder.new
        folder.title = 'Odeslaná pošta'
        folder.user = @user
        folder.type = 'outbox'
        folder.save
      end
    end
    @folders  = MailFolder.find(:all, :conditions => { :user_id => @user, :parent_id => nil })
    @messages = MailMessage.find(:all, :conditions => { :folder_id => @folder })
  end

  def compose    
  end

  def recipients
    sql = "
        SELECT `users`.`id`, `users`.`username`, `users`.`display`
          FROM `users`
          JOIN `memberships`
            ON `memberships`.`user_id` = `users`.`id`
          JOIN `groups`
            ON `memberships`.`group_id` = `groups`.`id`
          WHERE `groups`.`owner_type` = 'User' AND `groups`.`owner_id` = #{@user.id}
            AND ( `groups`.`type_id` = 4 OR `groups`.`type_id` = 3 )
          ORDER BY `users`.`username` DESC
    "
    users = []
    User.find_by_sql(sql).each do |u|
      users << { :id => u.id, :username => u.username, :display => u.display}
    end
    render :text => "document.recipients = " + users.to_json
  end

  def move
    msg = MailMessage.find(params[:message])
    folder = MailFolder.find(params[:folder])
    old = msg.folder
    msg.folder = folder
    msg.save
    redirect_to :action => 'index', :id => old
  end

  def new_folder
    folder = MailFolder.new
    folder.title = params[:id]
    folder.user = @user
    folder.type = 'folder'
    folder.save
    redirect_to :action => 'index', :id => folder
  end

  def sending
    params[:recipients].each do |r|
      recipient = User.find(r)
      if recipient
        inbox = MailFolder.find(:first, :conditions => { :user_id => recipient, :type => 'inbox' })
        outbox = MailFolder.find(:first, :conditions => { :user_id => @user, :type => 'outbox' })
        m = MailMessage.new
        m.body        = params[:text]
        m.subject     = params[:subject]
        m.sender      = @user
        m.recipient   = recipient
        m.folder = inbox
        m.save
        m = MailMessage.new
        m.body        = params[:text]
        m.subject     = params[:subject]
        m.sender      = recipient
        m.recipient   = @user
        m.folder = outbox
        m.save
      end
    end
    redirect_to :action => 'index'
  end

  def message
    m = MailMessage.find(params[:id])
    if m.recipient == @user or m.sender == @user then
      data = { :body => m.body, :subject => m.subject, :from => m.sender.display }
      render :text => data.to_json
    else
      render :text => '[]'
    end
  end

end
