class BinaryToStoreHistoryData < ActiveRecord::Migration
  def self.up
    change_column :histories, :options, :binary
  end

  def self.down
    change_column :histories, :options, :text
  end
end
