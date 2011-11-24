class ChangeFeedEntryDateToDateFromString < ActiveRecord::Migration
  def self.up
    change_column :feed_entries, :published, :datetime
  end

  def self.down
    change_column :feed_entries, :published, :string
  end
end
