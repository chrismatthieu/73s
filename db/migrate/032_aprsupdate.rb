class Aprsupdate < ActiveRecord::Migration
  def self.up
    create_table :aprsupdates do |t|
      t.datetime :published
    end
  end

  def self.down
    drop_table :aprsupdates
  end
end
