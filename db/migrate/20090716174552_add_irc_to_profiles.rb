class AddIrcToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :irc_name, :string
    add_column :profiles, :echolink_name, :string
  end

  def self.down
    remove_column :profiles, :irc_name
    remove_column :profiles, :echolink_name
  end
end
