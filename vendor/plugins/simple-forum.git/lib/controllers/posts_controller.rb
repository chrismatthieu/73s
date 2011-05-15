class PostsController < ActionController::Base
  
  skip_filter :login_required, :only => [:index, :show]
  
  
  helper ForumHelper
  include ForumHelper

  before_filter :setup_forum_and_topic
  before_filter :authorize, :only => [:edit, :update]

  def new
    @post = ForumPost.new
  end

  def create
    params[:forum_post].merge! :user_id => user.id

    post = @topic.posts.create! params[:forum_post]

    forum_session.add_post(post) if post

    redirect_to forum_topic_path(@forum, @topic)
  end

  def edit
    @post = @topic.posts.find params[:id]
  end

  def update
    ForumPost.update params[:id], params[:forum_post]
    redirect_to forum_topic_path(@forum, @topic)
  end

  def destroy
    @post = @topic.posts.find params[:id]
    @post.destroy if @post && @post.user == user
    redirect_to forum_topic_path(@forum, @topic)
  end

  private
  def setup_forum_and_topic
    @forum = Forum.find(params[:forum_id])
    @topic = @forum.topics.find(params[:topic_id])
  end

  def authorize
    post = ForumPost.find(params[:id])
    unless post.user == user && forum_session.can_edit_post?(post)
      flash[:error] = "No puedes editar este comentario."
      redirect_to forum_topic_path(@forum, @topic)
    end
  end
  
  protected
  
  
  def allow_to
    super :owner, :all => true
    super :all, :only => [:index, :show]
  end
  
end