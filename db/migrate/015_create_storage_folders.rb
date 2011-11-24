class CreateStorageFolders < ActiveRecord::Migration
  def self.up
    create_table :storage_folders do |t|
      t.string        :name
      t.string        :description
      t.references    :parent
      t.timestamps
    end
  end

  def self.down
    drop_table :storage_folders
  end
end
