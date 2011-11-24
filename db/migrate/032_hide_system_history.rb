class HideSystemHistory < ActiveRecord::Migration
  def self.up
    add_column :histories, :show, :boolean, :default => true
  end

  def self.down
    remove_column :histories, :show
  end
end
