class Club < ActiveRecord::Base
  belongs_to :profile

  validates_presence_of     :clubname
  validates_uniqueness_of   :clubname

end
