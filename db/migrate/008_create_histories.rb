class CreateHistories < ActiveRecord::Migration
  def self.up
    create_table :histories do |t|
      t.references  :user
      t.references  :object, :polymorphic => true
      t.string      :type
      t.string      :data
      t.timestamps
    end
  end

  def self.down
    drop_table :histories
  end
end
