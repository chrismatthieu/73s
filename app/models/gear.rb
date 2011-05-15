class Gear < ActiveRecord::Base
  belongs_to :profile

  validates_presence_of   :title
  validates_presence_of   :desc
  validates_presence_of   :price

end
