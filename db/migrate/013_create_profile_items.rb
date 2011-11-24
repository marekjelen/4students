class CreateProfileItems < ActiveRecord::Migration
  def self.up
    create_table :profile_items do |t|
      t.references    :section
      t.string        :title
      t.string        :type
      t.string        :value
      t.timestamps
    end
    add_index :profile_items, :section_id
  end

  def self.down
    drop_table :profile_items
  end
end
