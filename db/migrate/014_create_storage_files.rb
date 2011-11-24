class CreateStorageFiles < ActiveRecord::Migration
  def self.up
    create_table :storage_files do |t|
      # System
      t.string      :name
      t.string      :file
      t.string      :type
      t.references  :folder
      t.integer     :size
      # User
      t.string      :title
      t.string      :description
      t.timestamps
    end
  end

  def self.down
    drop_table :storage_files
  end
end
