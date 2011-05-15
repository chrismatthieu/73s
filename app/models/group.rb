class Group < ActiveRecord::Base
  belongs_to :profile
  has_many :groupers
  
  validates_presence_of     :title, :description
  validates_uniqueness_of   :title
end
