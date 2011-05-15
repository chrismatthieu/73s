class Hambrief < ActiveRecord::Base

  validates_presence_of   :title
  validates_presence_of   :episode
  validates_presence_of   :description
  validates_presence_of   :embedcode
    
end
