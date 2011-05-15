class CreateRepeaters < ActiveRecord::Migration
  def self.up
    create_table :repeaters do |t|
      t.string :trustee
      t.string :frequency
      t.string :long
      t.string :lat
      t.string :city
      t.string :state
      t.string :range
      t.string :offset
      t.string :pl
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :repeaters
  end
end
