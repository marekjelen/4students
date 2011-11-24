class CreateMemberships < ActiveRecord::Migration
  def self.up
    create_table :memberships do |t|
      t.references  :group
      t.references  :user
      t.boolean     :active, :default => 1
      t.timestamps
    end
    add_index :memberships, [:group_id, :user_id, :active]
  end

  def self.down
    drop_table :memberships
  end
end
