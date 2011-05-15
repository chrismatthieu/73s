class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table "ratings", :force => true do |t|
      t.column "rating", :integer, :default => 0, :null => false
      t.column "timestamp", :timestamp
      t.column "profile_id", :integer, :limit => 20, :default => 0, :null => false
      t.column "controllername", :string, :limit => 25, :default => "", :null => false
      t.column "controllerid", :integer, :limit => 20, :default => 0, :null => false
    end
  end

  def self.down
    drop_table :ratings
  end
end
