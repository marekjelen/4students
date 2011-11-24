class CreateFeedSubscribtions < ActiveRecord::Migration
  def self.up
    create_table :feed_subscribtions do |t|
      t.references    :feed
      t.references    :user
      t.string        :url
      t.string        :name
      t.timestamps
    end
  end

  def self.down
    drop_table :feed_subscribtions
  end
end
