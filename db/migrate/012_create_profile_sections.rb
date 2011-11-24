class CreateProfileSections < ActiveRecord::Migration
  def self.up
    create_table :profile_sections do |t|
      t.references    :profile
      t.string        :title
      t.string        :type
      t.timestamps
    end
    add_index :profile_sections, :profile_id
  end

  def self.down
    drop_table :profile_sections
  end
end
