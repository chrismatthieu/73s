class Status < ActiveRecord::Base
  belongs_to :profile
  validates_presence_of :message
  validates_length_of :message, :within => 1..140
  
  def after_create
    if self.privatemsg != true
      feed_item = FeedItem.create(:item => self)
      ([profile] + profile.friends + profile.followers).each{ |p| p.feed_items << feed_item }
    end
  end
  
end
