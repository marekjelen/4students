class LoadBasicData2 < ActiveRecord::Migration
  def self.up
    # Group type for members of club
    public = GroupType.new
    public.name = 'Members of club'
    public.save
    # Create basic groups
    pg = Group.new
    pg.active = 1
    pg.type = GroupType.find(1)
    pg.save
    pg = Group.new
    pg.active = 1
    pg.type = GroupType.find(2)
    pg.save
    # Asure all users are in Public and Logged in groups
    User.all.each do |user|
      pg = Group.find :first, :conditions => { :type_id => 1}
      pg.members << user unless pg.members.exists?( user )
      pg.save
      # Logged in users group
      lg = Group.find :first, :conditions => { :type_id => 2}
      lg.members << user unless lg.members.exists?( user )
      lg.save
    end
  end

  def self.down
  end
end
