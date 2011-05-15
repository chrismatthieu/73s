class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :eventname
      t.text :eventdesc
      t.date :eventdate
      t.time :starttime
      t.time :endtime
      t.string :eventcountry
      t.string :eventstate
      t.string :eventcity

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
