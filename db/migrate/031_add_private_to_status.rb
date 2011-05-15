class AddPrivateToStatus < ActiveRecord::Migration
  def self.up
    add_column :statuses, :privatemsg, :boolean, :default => 0
  end

  def self.down
    remove_column :statuses, :privatemsg
  end
end
