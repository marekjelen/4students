class CreateMailMessages < ActiveRecord::Migration
  def self.up
    create_table :mail_messages do |t|
      t.references     :sender
      t.references     :recipient
      t.string         :subject
      t.string         :body
      t.references     :folder
      t.timestamps
    end
  end

  def self.down
    drop_table :mail_messages
  end
end
