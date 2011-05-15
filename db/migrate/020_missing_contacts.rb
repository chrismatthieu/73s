class MissingContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :dxcc, :string
    add_column :contacts, :comment, :string
  end

  def self.down
    remove_column :contacts, :dxcc
    remove_column :contacts, :comment
  end
end
