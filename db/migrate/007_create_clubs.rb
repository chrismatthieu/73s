class CreateClubs < ActiveRecord::Migration
  def self.up
    create_table :clubs do |t|
      t.string :clubname
      t.text :clubdesc
      t.string :clubcountry
      t.string :clubstate
      t.string :clubcity

      t.timestamps
    end
  end

  def self.down
    drop_table :clubs
  end
end
