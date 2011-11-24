class ChangeHistories < ActiveRecord::Migration
  def self.up
    remove_column :histories, :data
    remove_column :histories, :type
    add_column    :histories, :key, :string
    add_column    :histories, :options, :text
  end

  def self.down
    remove_column :histories, :key
    remove_column :histories, :options
    add_column    :histories, :data, :string
    add_column    :histories, :type, :string
  end
end
