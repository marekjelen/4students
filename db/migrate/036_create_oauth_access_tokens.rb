class CreateOauthAccessTokens < ActiveRecord::Migration
  def self.up
    create_table :oauth_access_tokens do |t|
      t.string :key
      t.string :secure
      t.int :consumer_id
      t.int :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :oauth_access_tokens
  end
end
