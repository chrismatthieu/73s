class DirectoryController < ApplicationController

  skip_filter :login_required, :only => [:index, :show, :newest, :aprs, :twitterview, :skype]
  before_filter :setup


  def index
    @users = Profile.paginate(:order => 'created_at ASC', 
    :conditions => ["user_id > 0"],
    :per_page => 10,
    :page => params[:page])
    
    #@online = User.count(:conditions => ['last_active > ? and status != ?',Time.now - 3600, 'says 73s'])
    @online = 0

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end
  
  def newest
    @users = Profile.paginate(:order => 'created_at DESC', 
    :conditions => ['user_id <> ""'],
    :per_page => 10,
    :page => params[:page])
    render :action =>  'index'
  end

  def twitterview
    @users = Profile.paginate(:order => 'created_at ASC',
    :conditions => ['twitter_name <> "" and user_id <> ""'], 
    :per_page => 10,
    :page => params[:page])
    render :action =>  'index'
  end

  def aprs
    @users = Profile.paginate(:order => 'created_at ASC',
    :conditions => ['aprs = ? and user_id <> ""', true], 
    :per_page => 10,
    :page => params[:page])
    render :action =>  'index'
  end

  def skype
    @users = Profile.paginate(:order => 'created_at ASC',
    :conditions => ['skype_name <> "" and user_id <> ""'], 
    :per_page => 10,
    :page => params[:page])
    render :action =>  'index'
  end
  
  
  protected
  
  def setup
  end
  
  
  
  def allow_to
    super :owner, :all => true
    super :all, :only => [:index, :show, :newest, :aprs, :twitterview, :skype]
  end
  

end
