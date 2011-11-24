class CreateClubCategories < ActiveRecord::Migration
  def self.up
    create_table :club_categories do |t|
      t.string      :name
      t.string      :description
      t.string      :image
      t.integer     :lft
      t.integer     :rgt
      t.boolean     :active
      t.references  :parent
      t.timestamps
    end
    root = ClubCategory.new
    root.active = 1
    root.description = 'Kořenová kategorie'
    root.name = 'Kořenová kategorie'
    root.save
  end

  def self.down
    drop_table :club_categories
  end
end
