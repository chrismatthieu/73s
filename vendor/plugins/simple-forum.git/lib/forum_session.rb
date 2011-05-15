class ForumSession
  def initialize(session)
    @session = session
    @session[:forum_post_ids] ||= []
  end
  
  def add_post(post)
    @session[:forum_post_ids] << post.id
  end
  
  def can_edit_post?(post)
    @session[:forum_post_ids].include?(post.id) && post.created_at > 15.minutes.ago
  end
end
