class CreateGroupRosters < ActiveRecord::Migration
  def self.up
    create_table :group_rosters do |t|
      t.integer :profile_id
      t.integer :group_id

      t.timestamps
    end
  end

  def self.down
    drop_table :group_rosters
  end
end
