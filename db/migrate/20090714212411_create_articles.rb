class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.integer :product_id
      t.string :url
      t.date :publishdate
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
