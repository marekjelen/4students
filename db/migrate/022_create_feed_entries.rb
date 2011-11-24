class CreateFeedEntries < ActiveRecord::Migration
  def self.up
    create_table :feed_entries do |t|
      t.string      :title
      t.text        :description
      t.text        :link
      t.string      :guid
      t.string      :published
      t.string      :author
      t.references  :feed
      t.timestamps
    end
  end

  def self.down
    drop_table :feed_entries
  end
end
