class History < ActiveRecord::Base

  belongs_to :user
  belongs_to :object, :polymorphic => true

  def self.add user, object, type, options = {}
    history = History.new
    history.user = user
    history.object = object
    history.key = type.to_s
    history.show = true
    history.options = Marshal.dump(options)
    history.save
  end

  def self.system user, object, type, options = {}
    history = History.new
    history.user = user
    history.object = object
    history.key = type.to_s
    history.show = false
    history.options = Marshal.dump(options)
    history.save
  end

  def self.public
    options = {
            :joins => [ 'JOIN `memberships`', 'JOIN `history_publics`' ],
            :include => [ :user ],
            :conditions => ['`histories`.`show` = ? AND `histories`.`user_id` = `memberships`.`user_id` AND `histories`.`user_id` = `history_publics`.`user_id` AND `histories`.`key` = `history_publics`.`type` AND `history_publics`.`active` = ?', true, true],
            :order => '`histories`.`created_at` DESC'
    }
    History.find :all, options
  end

  def self.for_user user
    options = {
            :joins => [ 'JOIN groups', 'JOIN memberships' ],
            :include => [ :user ],
            :conditions => [ '`histories`.`show` = ? AND `histories`.`user_id` = `memberships`.`user_id` AND `groups`.`id` = `memberships`.`group_id` AND `groups`.`owner_id` = ? AND `groups`.`owner_type` = \'User\' AND `memberships`.`active` = ? AND ( `groups`.`type_id` = 4 OR `groups`.`type_id` = 3 )', true, user.id, true ],
            :order => '`histories`.`created_at` DESC'
    }
    History.find :all, options
  end

end