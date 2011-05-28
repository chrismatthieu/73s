class Company < ActiveRecord::Base

  has_many :products
  
  validates_presence_of :name, :url, :description
  
  # file_column :image, :magick => {
  #   :versions => { 
  #     :square => {:crop => "1:1", :size => "50x50", :name => "square"},
  #     :small => "175x250>"
  #   }
  # }
  

end
