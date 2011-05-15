class TopicsController < ActionController::Base
  skip_filter :login_required, :only => [:index, :show]
  
  
  helper ForumHelper
  include ForumHelper

  before_filter :setup_forum

  def show
    @topic = @forum.topics.find params[:id]
    @posts = @topic.posts.paginate :page => params[:page]
  end

  def new
    @topic = ForumTopic.new
  end

  def create
    params[:forum_topic].merge! :user_id => user.id
    params[:forum_post].merge! :user_id => user.id

    @topic = @forum.topics.create! params[:forum_topic]
    post = @topic.posts.create! params[:forum_post]

    forum_session.add_post(post) if post

    redirect_to @forum
  end

  private
  def setup_forum
    @forum = Forum.find(params[:forum_id])
  end
  
  protected
  
  
  def allow_to
    super :owner, :all => true
    super :all, :only => [:index, :show]
  end
  
end