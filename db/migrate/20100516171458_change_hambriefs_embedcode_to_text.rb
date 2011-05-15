class ChangeHambriefsEmbedcodeToText < ActiveRecord::Migration
  def self.up
    change_column :hambriefs, :embedcode, :text
  end

  def self.down
    change_column :hambriefs, :embedcode, :string
  end
end
