class AddVerifierToAccessToken < ActiveRecord::Migration
  def self.up
    add_column :oauth_access_tokens, :verifier, :string
  end

  def self.down
    remove_column :oauth_access_tokens, :verifier
  end
end
