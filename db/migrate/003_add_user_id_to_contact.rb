class AddUserIdToContact < ActiveRecord::Migration
  def self.up
    add_column :contacts, :profile_id, :integer
  end

  def self.down
    remove_column :contacts, :profile_id
  end
end
