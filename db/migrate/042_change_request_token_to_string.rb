class ChangeRequestTokenToString < ActiveRecord::Migration
  def self.up
    change_column :oauth_access_tokens, :request_token, :string
  end

  def self.down
    change_column :oauth_access_tokens, :request_token, :integer
  end
end
