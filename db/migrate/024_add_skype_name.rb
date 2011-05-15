class AddSkypeName < ActiveRecord::Migration
  def self.up
    add_column :profiles, :skype_name, :string
  end

  def self.down
    remove_column :profiles, :skype_name
  end
end
