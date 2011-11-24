class AddExpireAndActiveToAccessTokens < ActiveRecord::Migration
  def self.up
    add_column :oauth_access_tokens, :active, :boolean, :default => false
    add_column :oauth_access_tokens, :expire, :datetime
  end

  def self.down
    remove_column :oauth_access_tokens, :active
    remove_column :oauth_access_tokens, :expire
  end
end
