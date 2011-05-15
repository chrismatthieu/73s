class Rating < ActiveRecord::Base
  #belongs_to :candidates
  belongs_to :reviews
  belongs_to :products
end
