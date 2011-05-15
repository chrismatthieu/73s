class AddImageToCompanies < ActiveRecord::Migration
  def self.up
    add_column :companies, :image, :string
  end

  def self.down
    remove_column :companies, :image
  end
end
