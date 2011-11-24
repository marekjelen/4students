class CreateOauthConsumers < ActiveRecord::Migration
  def self.up
    create_table :oauth_consumers do |t|
      t.string :key
      t.string :secret
      t.boolean :active

      t.timestamps
    end
  end

  def self.down
    drop_table :oauth_consumers
  end
end
