class AddUserIdToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :profile_id, :integer
  end

  def self.down
    remove_column :events, :profile_id
  end

end
