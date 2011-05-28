class Product < ActiveRecord::Base
  has_many :forums
  has_many :articles
  has_many :ratings
  belongs_to :company
  belongs_to :list
  
  validates_presence_of :name, :url, :description
  
  # file_column :image, :magick => {
  #   :versions => { 
  #     :square => {:crop => "1:1", :size => "50x50", :name => "square"},
  #     :small => "175x250>"
  #   }
  # }
  
end
