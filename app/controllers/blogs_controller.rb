class BlogsController < ApplicationController
  skip_filter :login_required, :only => [:index, :show, :callsign, :rss, :all, :callsignshow]
  before_filter :setup, :except => [:callsign, :rss, :all, :callsignshow, :show]
  
  
  def index
    if @p && @p == @profile && @p.blogs.empty?
      flash[:notice] = 'You have not create any blog posts.  Try creating one now.' 
      redirect_to new_profile_blog_path(@p) and return
    end
    respond_to do |wants|
      wants.html {render}
      wants.rss {render :layout=>false}
      wants.iphone {render}
    end
  end
  
  # GET /clubs/new
  # GET /clubs/new.xml
  def new
    @blog = Blog.new

    respond_to do |format|
      format.html # new.html.erb
      format.iphone # new.html.erb
    end
  end  
  
  def create
    @blog = @p.blogs.build params[:blog]
    
    respond_to do |wants|
      if @blog.save
          flash[:notice] = 'New blog post created.'
          
          @twitusername = @p.twitter_name
          if @twitusername == nil || !@p.twitter_pass.blank?
            @twituser = ""
          else
            @twituser = " (@#{@twitusername})"
          end
          
          
          @tweet = @p.user.login + @twituser + " posted new blog entry - " + "http://73s.org/" + @p.user.login + "/blogs"
          twitter(@tweet) rescue ""
        wants.html do
          redirect_to profile_blogs_path(@p)
        end
        wants.iphone do
          redirect_to profile_blogs_path(@p)
        end
      else
        wants.html do
          flash.now[:error] = 'Failed to create a new blog post.'
          render :action => :new
        end
        wants.iphone do
          render :action => :new
        end
      end
    end
  end
  
  def show
    if !@profile.nil?
      render
    else
      redirect_to "/"
    end
  end
  
  def edit
    @blog = Blog[params[:id]]
    render
  end
  
  def update
    @blog = Blog[params[:id]]
    respond_to do |wants|
      if @blog.update_attributes(params[:blog])
        wants.html do
          flash[:notice]='Blog post updated.'
          redirect_to profile_blogs_path(@p)
        end
        wants.iphone { redirect_to profile_blogs_path(@p) }
      else
        wants.html do
          flash.now[:error]='Failed to update the blog post.'
          render :action => :edit
        end
      end
    end
  end
  
  def callsign
    @callsign = params[:callsign]
  
    #@user = User.find_by_login(@callsign) 
    @userx = User.find(:first, :conditions => ['login = ?', @callsign])
    
  
    if @userx

      params[:profile_id] = @userx.profile.id

      setup
      
      #index
      
      #render :action => 'index'
      
      respond_to do |wants|
        wants.html {render :action => 'index'}
        wants.rss {render  :action => 'index', :layout=>false}
      end
    
    else
      redirect_to(:controller => 'home', :action => 'callsign', :id => @callsign)
    end
  end

  def callsignshow
    @callsign = params[:callsign]
    @userx = User.find(:first, :conditions => ['login = ?', @callsign])
    if @userx
      params[:profile_id] = @userx.profile.id
      @profile = Profile[params[:profile_id]]
      @user = @profile.user

      @blog = Blog[params[:id]]
      @blogs = @profile.blogs.paginate(:page => @page, :per_page => @per_page)
      
      respond_to do |wants|
        wants.html {render :action => 'show'}
        # wants.rss {render  :action => 'index', :layout=>false}
      end
    
    else
      redirect_to(:controller => 'home', :action => 'callsign', :id => @callsign)
    end
  end
  
  def rss
    
    @blogs = Blog.find(:all, :order => 'updated_at DESC', :limit => 10)    
    respond_to do |wants|
      wants.html {render }
      wants.rss {render :action => 'rss', :layout=>false}
    end
    
  end

  def all
    
    #@blogs = Blog.find(:all, :order => 'updated_at DESC')  
    
    @blogs = Blog.paginate(:order => 'updated_at DESC', 
    :per_page => 5,
    :page => params[:page])
    
      
    respond_to do |wants|
      wants.html {render}
      wants.rss {render :action => 'rss', :layout=>false}
    end
    
  end
  
  def destroy
    @blog = Blog.find(params[:id])
    @blog.destroy
    respond_to do |wants|
      wants.html do
        flash[:notice]='Blog post deleted.'
        redirect_to profile_blogs_path(@p)
      end
    end
  end


  protected
  
  def setup
    @profile = Profile[params[:profile_id]]
    @user = @profile.user
    @blogs = @profile.blogs.paginate(:page => @page, :per_page => @per_page)
          
    if params[:id]
      # @blog = Blog[params[:id]]
      # @blogs = Blog[params[:id]]
    else
      # @blogs = @profile.blogs.paginate(:page => @page, :per_page => @per_page)
      # @blog = Blog.new
    end
  end
  
  
  
  def allow_to
    super :owner, :all => true
    super :all, :only => [:index, :show, :callsign, :rss, :all, :destroy, :callsignshow]
  end
  
end
