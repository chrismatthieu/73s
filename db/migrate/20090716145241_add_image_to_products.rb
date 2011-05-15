class AddImageToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :image, :string
  end

  def self.down
    remove_column :products, :image
  end
end
