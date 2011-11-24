class CreateClubMessages < ActiveRecord::Migration
  def self.up
    create_table :club_messages do |t|
      t.references  :user
      t.references  :club
      t.text        :message
      t.timestamps
    end
  end

  def self.down
    drop_table :club_messages
  end
end
