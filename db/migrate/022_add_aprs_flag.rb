class AddAprsFlag < ActiveRecord::Migration
  def self.up
    add_column :profiles, :aprs, :boolean, :default => 0
  end

  def self.down
    remove_column :profiles, :aprs
  end
end
