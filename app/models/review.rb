class Review < ActiveRecord::Base

   acts_as_taggable
   
   belongs_to :profile
   has_many :comments
   has_many :ratings
  
  validates_presence_of :title, :body

  def to_param
    "#{id}-#{title[0, 140].gsub(/[^a-z1-9]+/i, '-')}"
  end


end
