class List < ActiveRecord::Base
  belongs_to :product
  belongs_to :profile

  def after_save
    profile = Profile.find(:first, :conditions => ["id = ?", self.user_id])
    feed_item = FeedItem.create(:item => self)
    ([profile] + profile.friends + profile.followers).each{ |p| p.feed_items << feed_item }
  end

end
