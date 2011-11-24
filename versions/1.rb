def _upgrade user
  # Crate user self-group
  ug = Group.new
  ug.owner = user
  ug.active = 1
  ug.type = GroupType.find(3)
  ug.members << user
  ug.save
  # Create user friends-group
  fg = Group.new
  fg.owner = user
  fg.active = 1
  fg.type = GroupType.find(4)
  fg.save
  # Public users group
  pg = Group.find :first, :conditions => { :type_id => 1}
  pg.members << user
  pg.save
  # Logged in users group
  lg = Group.find :first, :conditions => { :type_id => 2}
  lg.members << user
  lg.save
  # Create profile
  profile = Profile.new
  profile.user = user
  profile.save
end