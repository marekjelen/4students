class CreateHistoryPublics < ActiveRecord::Migration
  def self.up
    create_table :history_publics do |t|
      t.references    :user
      t.string        :type
      t.boolean       :active, :default => true
      t.timestamps
    end
    add_index :history_publics, [:user_id, :type], :unique => true
    add_index :history_publics, [:user_id, :type, :active]
  end

  def self.down
    drop_table :history_publics
  end
end
