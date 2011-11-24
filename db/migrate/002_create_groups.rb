class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.references  :owner, :polymorphic => true
      t.boolean     :active
      t.references  :type
      t.string      :name
      t.string      :description 
      t.timestamps
    end
    add_index :groups, [:owner_id, :owner_type]
    add_index :groups, [:owner_id, :owner_type, :active, :type_id]
  end

  def self.down
    drop_table :groups
  end
end
