class AddUserIdToClub < ActiveRecord::Migration
  def self.up
    add_column :clubs, :profile_id, :integer
  end

  def self.down
    remove_column :clubs, :profile_id
  end
end
