class CreateResources < ActiveRecord::Migration
  def self.up
    create_table :resources do |t|
      t.string      :title
      t.string      :description
      t.boolean     :active
      t.text        :searchable
      t.references  :object, :polymorphic => true
      t.timestamps
    end
  end

  def self.down
    drop_table :resources
  end
end
