class LockedClub < ActiveRecord::Migration
  def self.up
    add_column :clubs, :locked, :boolean
  end

  def self.down
  end
end
