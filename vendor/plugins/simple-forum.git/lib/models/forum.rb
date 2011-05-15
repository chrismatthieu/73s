class Forum < ActiveRecord::Base
  #validates_presence_of :title
  #validates_length_of :title, :within => 3..100

  has_many :topics, :class_name => "ForumTopic", :foreign_key => "forum_id", :order => "last_post_at DESC, created_at DESC"
  belongs_to :last_poster, :class_name => "User", :foreign_key => "last_post_by"
  # has_and_belongs_to_many :moderators, :class_name => "User", :join_table => "forums_users", :foreign_key => "user_id"
  has_and_belongs_to_many :moderators, :class_name => "User", :join_table => "forums_users"

  # TODO : add counter cache
  def posts_count
    topics.inject(0) {|x,y| x+y.posts.count}
  end
end
