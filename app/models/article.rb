class Article < ActiveRecord::Base
  belongs_to :product
  
  validates_presence_of :url, :description
end
