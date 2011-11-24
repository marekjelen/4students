class RenameColumnsInAccessTokens < ActiveRecord::Migration
  def self.up
    rename_column :oauth_access_tokens, :key, :token
    rename_column :oauth_access_tokens, :secure, :secret
  end

  def self.down
    rename_column :oauth_access_tokens, :token, :key
    rename_column :oauth_access_tokens, :secret, :secure
  end
end
