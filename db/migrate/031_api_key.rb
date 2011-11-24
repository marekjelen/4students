class ApiKey < ActiveRecord::Migration
  def self.up
    add_column :users, :api, :string
  end

  def self.down
    remove_column :users, :api
  end
end
