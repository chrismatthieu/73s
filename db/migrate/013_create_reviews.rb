class CreateReviews < ActiveRecord::Migration
  def self.up
    create_table :reviews do |t|
      t.column "profile_id", :integer, :limit => 20, :default => 0, :null => false
      t.column "title", :string, :limit => 255, :default => "", :null => false
      t.column "body", :text, :default => "", :null => false
      t.column "rating", :float
      t.column "timestamp", :timestamp
      t.column "thumbsup", :integer, :default => 0, :null => true
      t.column "thumbsdown", :integer, :default => 0, :null => true
      t.column "emailcomments", :boolean, :default => true, :null => false
      t.column "viewcount", :integer, :default => 0, :null => false      
    end
  end

  def self.down
    drop_table :reviews
  end
end
