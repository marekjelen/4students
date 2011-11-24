class AddInvitationColumnToClub < ActiveRecord::Migration
  def self.up
    add_column :memberships, :invitation, :boolean
  end

  def self.down
  end
end
