def _upgrade user
  root = StorageFolder.new
  root.description = 'Kořenová složka'
  root.name = 'Kořenová složka'
  root.save

  perm = Permission.new
  perm.granted = true
  perm.group = Group.find :first, :conditions => { :owner_id => user, :owner_type => 'User', :type_id => 3}
  perm.right = Right.find :first, :conditions => { :keyword => "own" }
  perm.object = root
  perm.active = true
  perm.save
end