class LoadGroupsBasicData < ActiveRecord::Migration
  def self.up
    # Basic group types
    public = GroupType.new
    public.name = 'Public users'
    public.save
    logged = GroupType.new
    logged.name = 'Logged-in users'
    logged.save
    itself = GroupType.new
    itself.name = 'User itselfs'
    itself.save
    friends = GroupType.new
    friends.name = 'Friends'
    friends.save
    # Basic rights
    own = Right.new
    own.keyword = 'own'
    own.save
    read = Right.new
    read.keyword = 'read'
    read.save
    write = Right.new
    write.keyword = 'write'
    write.save
    delete = Right.new
    delete.keyword = 'delete'
    delete.save
    overwrite = Right.new
    overwrite.keyword = 'overwrite'
    overwrite.save
    view = Right.new
    view.keyword = 'view'
    view.save
    access = Right.new
    access.keyword = 'access'
    access.save
    open = Right.new
    open.keyword = 'open'
    open.save
  end

  def self.down
  end
end
