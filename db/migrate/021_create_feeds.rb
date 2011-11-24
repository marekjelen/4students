class CreateFeeds < ActiveRecord::Migration
  def self.up
    create_table :feeds do |t|
      t.string      :title
      t.text        :text
      t.text        :description
      t.text        :url
      t.string      :lang
      t.datetime    :lastUpdate
      t.datetime    :lastFetch
      t.integer     :ttl
      t.timestamps
    end
  end

  def self.down
    drop_table :feeds
  end
end
