class CreateAdverts < ActiveRecord::Migration
  def self.up
    create_table :adverts do |t|
      t.integer :profile_id
      t.text :description
      t.integer :placement
      t.string :name
      t.string :content_type
      t.binary :data
      t.datetime :startdate
      t.datetime :enddate
      t.string :url
      t.integer :viewcount
      t.integer :clickcount

      t.timestamps
    end
  end

  def self.down
    drop_table :adverts
  end
end
