class AddRequestTokenToAccessToken < ActiveRecord::Migration
  def self.up
    add_column :oauth_access_tokens, :request_token, :integer
  end

  def self.down
    remove_column :oauth_access_tokens, :request_token
  end
end
