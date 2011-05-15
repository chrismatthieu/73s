class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.string :callsign
      t.string :name
      t.string :email
      t.string :country
      t.string :state
      t.string :city
      t.string :frequency
      t.string :signal
      t.string :event
      t.text :notes
      t.datetime :contacttime

      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
