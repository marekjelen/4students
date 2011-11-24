class AddUserToRequestToken < ActiveRecord::Migration
  def self.up
    add_column :oauth_request_tokens, :user, :integer
  end

  def self.down
    remove_column :oauth_request_tokens, :user
  end
end
