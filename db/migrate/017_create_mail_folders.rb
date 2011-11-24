class CreateMailFolders < ActiveRecord::Migration
  def self.up
    create_table :mail_folders do |t|
      t.string      :title
      t.string      :type
      t.references  :parent
      t.references  :user
      t.timestamps
    end
  end

  def self.down
    drop_table :mail_folders
  end
end
