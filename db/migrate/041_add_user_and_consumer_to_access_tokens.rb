class AddUserAndConsumerToAccessTokens < ActiveRecord::Migration
  def self.up
    add_column :oauth_access_tokens, :user_id, :integer
    add_column :oauth_access_tokens, :consumer_id, :integer
  end

  def self.down
    remove_column :oauth_access_tokens, :user_id
    remove_column :oauth_access_tokens, :consumer_id
  end
end
