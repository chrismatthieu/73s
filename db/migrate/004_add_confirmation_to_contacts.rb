class AddConfirmationToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :confirmed, :datetime
  end

  def self.down
    remove_column :contacts, :confirmed
  end
end
