class CreateOauthRequestTokens < ActiveRecord::Migration
  def self.up
    create_table :oauth_request_tokens do |t|
      t.string :token
      t.string :secret
      t.binary :request

      t.timestamps
    end
  end

  def self.down
    drop_table :oauth_request_tokens
  end
end
