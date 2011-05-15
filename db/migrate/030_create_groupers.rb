class CreateGroupers < ActiveRecord::Migration
  def self.up
    create_table :groupers do |t|
      t.integer :profile_id
      t.integer :group_id

      t.timestamps
    end
  end

  def self.down
    drop_table :groupers
  end
end
