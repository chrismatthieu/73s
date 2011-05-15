class CreateHambriefs < ActiveRecord::Migration
  def self.up
    create_table :hambriefs do |t|
      t.integer :episode
      t.string :title
      t.text :description
      t.string :embedcode

      t.timestamps
    end
  end

  def self.down
    drop_table :hambriefs
  end
end
