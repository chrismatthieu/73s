class AddAdifFieldsToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :address, :string
    add_column :contacts, :age, :string
    add_column :contacts, :arrl_sect, :string
    add_column :contacts, :band, :string
    add_column :contacts, :county, :string
    add_column :contacts, :continent, :string
    add_column :contacts, :contestid, :string
    add_column :contacts, :cqzone, :string
    add_column :contacts, :gridsquare, :string
    add_column :contacts, :iota, :string
    add_column :contacts, :ituzone, :string
    add_column :contacts, :mode, :string
    add_column :contacts, :wpxprefix, :string
    add_column :contacts, :propmode, :string
    add_column :contacts, :qslmessage, :string
    add_column :contacts, :qslreceivedate, :datetime
    add_column :contacts, :qslsentdate, :datetime
    add_column :contacts, :qth, :string
    add_column :contacts, :rstreceived, :string
    add_column :contacts, :rstsent, :string
    add_column :contacts, :rxpower, :string
    add_column :contacts, :satellitemode, :string
    add_column :contacts, :satellitename, :string
    add_column :contacts, :serialreceived, :string
    add_column :contacts, :serialsent, :string
    add_column :contacts, :tenten, :string
    add_column :contacts, :timeoff, :datetime
    add_column :contacts, :timeone, :datetime
    add_column :contacts, :txpower, :string
    add_column :contacts, :veprov, :string
  end

  def self.down
    remove_column :contacts, :address
    remove_column :contacts, :age
    remove_column :contacts, :arrl_sect
    remove_column :contacts, :band
    remove_column :contacts, :county
    remove_column :contacts, :continent
    remove_column :contacts, :contestid
    remove_column :contacts, :cqzone
    remove_column :contacts, :gridsquare
    remove_column :contacts, :iota
    remove_column :contacts, :ituzone
    remove_column :contacts, :mode
    remove_column :contacts, :wpxprefix
    remove_column :contacts, :propmode
    remove_column :contacts, :qslmessage
    remove_column :contacts, :qslreceivedate
    remove_column :contacts, :qslsentdate
    remove_column :contacts, :qth
    remove_column :contacts, :rstreceived
    remove_column :contacts, :rstsent
    remove_column :contacts, :rxpower
    remove_column :contacts, :satellitemode
    remove_column :contacts, :satellitename
    remove_column :contacts, :serialreceived
    remove_column :contacts, :serialsen
    remove_column :contacts, :tenten
    remove_column :contacts, :timeoff
    remove_column :contacts, :timeone
    remove_column :contacts, :txpower
    remove_column :contacts, :veprov

  end
end
