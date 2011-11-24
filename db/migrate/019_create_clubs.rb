class CreateClubs < ActiveRecord::Migration
  def self.up
    create_table :clubs do |t|
      t.string      :name
      t.string      :description
      t.boolean     :active
      t.references  :category
      t.boolean     :public
      t.boolean     :visible
      t.timestamps
    end
  end

  def self.down
    drop_table :clubs
  end
end
