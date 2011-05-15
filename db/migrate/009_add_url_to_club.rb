class AddUrlToClub < ActiveRecord::Migration
  def self.up
    add_column :clubs, :cluburl, :string
  end

  def self.down
    remove_column :clubs, :cluburl
  end
end
