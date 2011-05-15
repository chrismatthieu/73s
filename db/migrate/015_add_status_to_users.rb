class AddStatusToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :status, :string
    add_column :users, :last_active, :datetime
  end

  def self.down
    remove_column :users, :status
    remove_column :users, :last_active
  end
end
