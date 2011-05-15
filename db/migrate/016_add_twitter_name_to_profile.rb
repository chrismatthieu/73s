class AddTwitterNameToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :twitter_name, :string
  end

  def self.down
    remove_column :profiles, :twitter_name
  end
end
