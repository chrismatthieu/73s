class AddSummaryFlagToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :supresssummary, :boolean, :default => 0
  end

  def self.down
    remove_column :profiles, :supresssummary
  end
end
