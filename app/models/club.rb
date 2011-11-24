class Club < ActiveRecord::Base
  validates_presence_of     :name, :description
  belongs_to :category, :class_name => 'ClubCategory'

  def group
    Group.find :first, :conditions => {
      :type_id => 5,
      :owner_type => 'Club',
      :owner_id => self.id,
      :active => true
    }
  end

  def members
    self.allmembers
  end

  def allmembers
    options = {
            :joins => ['JOIN `memberships`', 'JOIN `groups`'],
            :conditions => [ "`memberships`.`user_id` = `users`.`id` AND `memberships`.`active` = ? AND `memberships`.`group_id` = `groups`.`id` AND `groups`.`type_id` = 5 AND `groups`.`owner_type` = 'Club' AND `groups`.`owner_id` = ? AND `groups`.`active` = ? AND `users`.`active` = ?", true, self.id, true, true ]
    }
    User.find :all, options
  end

  def member? user
    (Membership.find :first, :conditions => { :group_id => self.group.id, :user_id => user.id, :active => true }) != nil
  end
  
  def member user
    if not self.member? user
      ms = Membership.new
      ms.user = user
      ms.group = self
      ms.active = true
      ms.save
    end
  end

  def member! user
    ms = Membership.find :first, :conditions => { :group_id => self.group.id, :user_id => user.id }
    if ms
      ms.delete
    end
  end
end
