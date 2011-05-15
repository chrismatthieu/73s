class AddConfirmationCodeToContact < ActiveRecord::Migration
  def self.up
    add_column :contacts, :confirmation_code, :string, :limit => 40
  end

  def self.down
    remove_column :contacts, :confirmation_code
  end
end
