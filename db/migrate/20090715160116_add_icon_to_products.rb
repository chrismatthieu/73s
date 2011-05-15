class AddIconToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :icon, :binary
  end

  def self.down
    remove_column :products, :icon
  end
end
