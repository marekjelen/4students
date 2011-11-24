class User < ActiveRecord::Base

  # Settings
  attr_protected :id, :active, :created_at, :updated_at, :status, :code, :display
  # Validation
  validates_uniqueness_of :username, :email
  validates_presence_of :name, :surname
  validates_length_of :username,  :within => 5..255
  validates_length_of :password,  :within => 5..255
  validates_format_of :email,     :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_confirmation_of :password
  validates_format_of :username,  :with => /^[0-9A-Za-z_]+$/i
  # Acts

  # Relationships
  has_one :profile, :include => [:sections]
  has_one :mygroup, :class_name => 'Group', :conditions => {:type_id => 3, :active => true, :owner_type => 'User'}, :foreign_key => 'owner_id'

  # Hooks
  def before_create
    # Generate validation code
    self.makecode false
    self.display = self.name + ' ' + self.surname
  end

  # Generic functions
  # E-mail confirmation
  def self.confirm code
    user = User.find(:first, :conditions => { :code => code } )
    return nil if not user
    return nil if user.active
    user.active = true
    user.save
    return user
  end

  # Authentication
  def self.authenticate username, password
    return User.find(:first, :conditions => {
            :username => username,
            :password => Digest::SHA1.hexdigest(password),
            :active => true
    })
  end

  # User functions
  # Create code
  def api_key!
    self.api = Digest::SHA1.hexdigest(Time.now.to_s + self.username + self.email)
    self.save
  end

  def makecode save = true
    data = Time.now.to_s + self.username + self.email
    self.code = Digest::SHA1.hexdigest(data)
    if save
      self.save
    end
    return self.code
  end

  # Changes user's status and adds history
  def change_status status
    self.status = status
    self.save
    History.add self, nil, :status, { :status => status }
  end

  # Find friendship requests
  def friend_requests
    options = {
            :joins => ['JOIN `memberships`', 'JOIN `groups`'],
            :conditions => ["`users`.`id` = `memberships`.`user_id` AND `memberships`.`group_id` = `groups`.`id` AND `memberships`.`active` = ? AND `groups`.`owner_id` = ? AND `groups`.`owner_type` = 'User' AND `groups`.`type_id` = ?", false, self.id, 4],
            :order => '`memberships`.`created_at` DESC'
    }
    User.find :all, options
  end

  # Find friends
  def friends
    options = {
            :joins => [ 'JOIN `groups`', 'JOIN `memberships`' ],
            :conditions => ['`users`.`id` = `groups`.`owner_id` AND `groups`.`owner_type` = ? AND `memberships`.`group_id` = `groups`.`id` AND `memberships`.`user_id` = ? AND `groups`.`type_id` = ?', 'User', self.id, 4],
            :order => '`memberships`.`created_at` DESC'
    }
    User.find :all, options
  end

  # Published histories
  def published_histories
    all = HistoryPublic.find(:all, :conditions => {:user_id => self.id})
    pubed = []
    all.each do |one|
      pubed << one['type']
    end
    return pubed
  end

  def publish_histories items = []
    HistoryPublic.delete_all( :user_id => self.id)
    if items
      items.each do |item|
        p = HistoryPublic.new
        p.type = item
        p.user = self
        p.active = 1
        p.save
      end
    end
  end

  def clubs_active
    Club.find_by_sql [ "SELECT `clubs`.* FROM `clubs`
       JOIN `groups` ON `groups`.`owner_type` = 'Club' AND `groups`.`owner_id` = `clubs`.`id`
       JOIN `memberships` ON `memberships`.`group_id` = `groups`.`id` AND `memberships`.`user_id` = ?
        AND `memberships`.`active` = ?", self.id, true ]
  end

  def clubs_requests
    Club.find_by_sql [ "SELECT `clubs`.* FROM `clubs`
       JOIN `groups` ON `groups`.`owner_type` = 'Club' AND `groups`.`owner_id` = `clubs`.`id`
       JOIN `memberships` ON `memberships`.`group_id` = `groups`.`id` AND `memberships`.`user_id` = ?
        AND `memberships`.`active` = ? AND `memberships`.`invitation` = ?", self.id, false, false ]
  end

  def clubs_invitations
    Club.find_by_sql [ "SELECT `clubs`.* FROM `clubs`
       JOIN `groups` ON `groups`.`owner_type` = 'Club' AND `groups`.`owner_id` = `clubs`.`id`
       JOIN `memberships` ON `memberships`.`group_id` = `groups`.`id` AND `memberships`.`user_id` = ?
        AND `memberships`.`active` = ? AND `memberships`.`invitation` = ?", self.id, false, true ]
  end

  def gravatar_url(gravatar_options={})
    gravatar_options[:rating] ||= nil
    gravatar_options[:default] ||= nil
    grav_url = 'http://www.gravatar.com/avatar.php?'
    grav_url << "gravatar_id=#{Digest::MD5.new.update(self.email)}"
    grav_url << "&rating=#{gravatar_options[:rating]}" if gravatar_options[:rating]
    grav_url << "&size=#{gravatar_options[:size]}" if gravatar_options[:size]
    grav_url << "&default=#{gravatar_options[:default]}" if gravatar_options[:default]
    grav_url
  end

  def avatar_url options={}
    options[:size] ||= 32
    if self.avatar == 'local'

    else
      self.gravatar_url(options)
    end
  end
end
