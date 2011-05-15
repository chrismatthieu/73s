class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.integer :profile_id
      t.string :title
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :groups
  end
end
