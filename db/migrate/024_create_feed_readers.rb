class CreateFeedReaders < ActiveRecord::Migration
  def self.up
    create_table :feed_readers do |t|
      t.references  :user
      t.references  :entry
      t.boolean     :read, :default => false
      t.boolean     :delete, :default => false
      t.boolean     :bookmark, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :feed_readers
  end
end
