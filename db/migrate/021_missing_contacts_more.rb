class MissingContactsMore < ActiveRecord::Migration
  def self.up
    add_column :contacts, :qslreceived, :string
    add_column :contacts, :qslsent, :string
    add_column :contacts, :qslvia, :string
  end

  def self.down
    remove_column :contacts, :qslreceived
    remove_column :contacts, :qslsent
    remove_column :contacts, :qslvia
  end
end
