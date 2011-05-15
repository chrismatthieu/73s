class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.integer :company_id
      t.integer :forum_id
      t.string :category
      t.string :name
      t.string :url
      t.text :description
      t.boolean :dstar
      t.boolean :aprs
      t.boolean :computer
      t.boolean :vox
      t.boolean :fm
      t.boolean :cw
      t.boolean :ssb
      t.boolean :am
      t.boolean :head
      t.boolean :speaker
      t.boolean :preamp
      t.boolean :swr
      t.boolean :submersible
      t.boolean :widereceive
      t.boolean :cwtrainer
      t.boolean :gps
      t.boolean :barometer
      t.boolean :temperature
      t.boolean :dualband
      t.boolean :bluetooth
      t.string :minpower
      t.string :maxpower
      t.string :lowestband
      t.string :highestband
      t.string :memorychannels
      t.string :display
      t.string :price

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
