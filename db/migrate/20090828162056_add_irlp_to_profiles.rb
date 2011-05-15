class AddIrlpToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :irlp_name, :string
  end

  def self.down
    remove_column :profiles, :irlp_name
  end
end
