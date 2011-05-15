class ForumTopic < ActiveRecord::Base
  #validates_presence_of :title
  #validates_length_of :title, :within => 3..100
  #validates_presence_of :user_id

  belongs_to :forum
  # belongs_to :profile
  belongs_to :user
  belongs_to :last_poster, :class_name => "User", :foreign_key => "last_post_by"
  has_many :posts, :class_name => "ForumPost", :foreign_key => "topic_id"

  def self.per_page
    20
  end

  def after_save
    forum.update_attributes :last_post_at => last_post_at,
                            :last_post_by => last_post_by
  end
  
  def after_create
    feed_item = FeedItem.create(:item => self)
    profile = Profile.find(:first, :conditions => ['user_id = ?', self.user_id])
    ([profile] + profile.friends + profile.followers).each{ |p| p.feed_items << feed_item }
  end
  
end
