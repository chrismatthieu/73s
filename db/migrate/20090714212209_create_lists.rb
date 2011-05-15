class CreateLists < ActiveRecord::Migration
  def self.up
    create_table :lists do |t|
      t.integer :user_id
      t.integer :product_id
      t.integer :status

      t.timestamps
    end
  end

  def self.down
    drop_table :lists
  end
end
