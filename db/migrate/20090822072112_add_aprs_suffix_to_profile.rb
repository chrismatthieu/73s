class AddAprsSuffixToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :aprs_suffix, :string
    add_column :profiles, :twitter_pass, :string
  end

  def self.down
    remove_column :profiles, :aprs_suffix
    remove_column :profiles, :twitter_pass
  end
end
