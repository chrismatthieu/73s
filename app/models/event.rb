class Event < ActiveRecord::Base

  belongs_to :profile

  validates_presence_of     :eventname
  validates_uniqueness_of   :eventname

end
