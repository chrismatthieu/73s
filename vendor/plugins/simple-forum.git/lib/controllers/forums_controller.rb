class ForumsController < ActionController::Base
  
  skip_filter :login_required, :only => [:index, :show]
    
  helper ForumHelper
  include ForumHelper

  def index
    @forums = Forum.find(:all, :order => 'last_post_at desc')
  end

  def show
    @forum = Forum.find(params[:id])
    @topics = @forum.topics.paginate :page => params[:page]
  end
  
  protected
  
  
  def allow_to
    super :owner, :all => true
    #super :user, :all => true
    super :all, :only => [:index, :show]
  end
  
end
