class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.references    :group
      t.references    :right
      t.references    :object, :polymorphic => true
      t.boolean       :active
      t.boolean       :granted
      t.timestamps
    end
    add_index :permissions, [:group_id, :right_id, :object_id, :object_type], :unique => true, :name => 'complex_index'
  end

  def self.down
    drop_table :permissions
  end
end
