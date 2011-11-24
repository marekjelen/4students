class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      # Login information
      t.string      :username
      t.string      :password
      t.boolean     :active, :default => false
      t.string      :code
      # User information
      t.string      :name
      t.string      :surname
      t.string      :email
      # System information
      t.integer     :version
      t.string      :display
      t.string      :avatar
      t.string      :status, :default => ''
      t.timestamps
    end
    add_index :users, :username, :unique => true
    add_index :users, [ :username, :password ]
    add_index :users, :email, :unique => true
  end

  def self.down
    drop_table :users
  end
end
