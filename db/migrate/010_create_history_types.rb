class CreateHistoryTypes < ActiveRecord::Migration
  def self.up
    create_table :history_types do |t|
      t.string      :name
      t.string      :title
      t.timestamps
    end
    add_index :history_types, :name, :unique => true
  end

  def self.down
    drop_table :history_types
  end
end
