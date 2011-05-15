class CreateGears < ActiveRecord::Migration
  def self.up
    create_table :gears do |t|
      t.string :title
      t.text :desc
      t.boolean :forsale
      t.float :price
      t.boolean :active
      t.integer :profile_id

      t.timestamps
    end
  end

  def self.down
    drop_table :gears
  end
end
