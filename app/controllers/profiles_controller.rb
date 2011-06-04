class ProfilesController < ApplicationController
  include ApplicationHelper
    
  before_filter :setup, :except => [:index, :search, :callsign]
  # before_filter :search_results, :only => [:index, :search]
  skip_filter :login_required, :only=>[:show, :index, :feed, :search, :callsign]

  def show
    # unless @profile.youtube_username.blank?
    #   begin
    #     client = YouTubeG::Client.new
    #     @video = client.videos_by(:user => @profile.youtube_username).videos.first
    #   rescue Exception, OpenURI::HTTPError
    #   end
    # end
    
    # begin
    #   @flickr = @profile.flickr_username.blank? ? [] : flickr_images(flickr.people.findByUsername(@profile.flickr_username))
    # rescue Exception, OpenURI::HTTPError
    #   @flickr = []
    # end
      
    @callelements = Array.new 
    @callelements[0] = @user.login
    @callelements[1] = @user.login
    @callelements[2] = @profile.full_name
    @callelements[3] = ""
    @callelements[4] = @profile.location
    @callelements[5] = ""
    @email = @profile.email
    @website = @profile.website      
    @callsign = @user.login

    @comments = @profile.comments.paginate(:page => @page, :per_page => 10)
    
    
    @statuses = Status.find(:first, :conditions => ["profile_id = ?", @profile.id], :order => "created_at desc")
    
    
    @contacts = @profile.contacts.count
    #@messages = @profile.messages.count(:conditions => 'read = 0')
    @messages = @profile.unread_messages.count.to_s
    
    respond_to do |wants|
      wants.html do
        @feed_items = @profile.feed_items
      end
      wants.xml do
        @feed_items = @profile.feed_items
        render :layout=>false
      end
      # wants.rss do 
      #   @feed_items = @profile.feed_items
      #   render :layout => false
      # end
      wants.iphone do
        @feed_items = @profile.feed_items
      end
    end
  end
  
  def search
    render
  end
  
  def index
    # render :action => :search
    redirect_to "/"
  end
  
  def edit
    render
  end
    
  
  def update
    case params[:switch]
    when 'name','image'
      if @profile.update_attributes params[:profile]
        flash[:notice] = "Settings have been saved."
        redirect_to edit_profile_url(@profile)
      else
        flash.now[:error] = @profile.errors
        render :action => :edit
      end
    when 'password'
      if @user.change_password(params[:verify_password], params[:new_password], params[:confirm_password], session[:admin])
        flash[:notice] = "Password has been changed."
        redirect_to edit_profile_url(@profile)
      else
        flash.now[:error] = @user.errors
        render :action=> :edit
      end
    when 'callsign'
      @user = User.find(:first, :conditions => ['id = ?', @profile.id])
      @user.login = params[:callsign]
      if @user.save
        flash[:notice] = "Your CallSign has been changed."
        redirect_to edit_profile_url(@profile)
      else
        flash.now[:error] = @user.errors
        render :action=> :edit
      end
    else
      RAILS_ENV == 'test' ? render( :text=>'') : raise( 'Unsupported swtich in action')
    end
  end


  def delete_icon
    respond_to do |wants|
      @p.update_attribute :icon, nil
      wants.js {render :update do |page| page.visual_effect 'Puff', 'profile_icon_picture' end  }
    end      
  end

  def deauth
    # deauth twitter - remove token and redirect to twitter revoke page
    @user.access_token = nil
    @user.access_secret = nil
    @user.save
    redirect_to "https://twitter.com/settings/applications"
  end



  def callsign
    @callsign = params[:callsign]
  
    #@user = User.find_by_login(@callsign) 
    # @user = User.find(:first, :conditions => ['login = ?', @callsign])
    # @user = User.find(:first, :conditions => ['login ILIKE ?', @callsign])           
    if request.url.index('localhost')
      @user = User.find(:first, :conditions => ['login LIKE ?', @callsign])         
    else
      @user = User.find(:first, :conditions => ['login ILIKE ?', @callsign])         
    end
    
  
    if @user

      #setup prep
      # @profile = Profile[@userx.id]      
      # @user = @profile.user

      @profile = @user.profile    
      
      show
      
      render :action => 'show', :id => @user.id
    
    else
      redirect_to(:controller => 'home', :action => 'callsign', :id => @callsign)
    end
  end



  def destroy
    respond_to do |wants|
     @user.destroy
      cookies[:auth_token] = {:expires => Time.now-1.day, :value => ""}
      session[:user] = nil
      wants.js do
        render :update do |page| 
          page.alert('Your user account, and all data, have been deleted.')
          page << 'location.href = "/";'
        end
      end
    end
    
  end




  private
  
  def allow_to
    super :owner, :all => true
    super :all, :only => [:show, :index, :search, :callsign]
  end
  
  def setup
    @profile = Profile[params[:id]]
    @user = @profile.user
  end
  
  def search_results
    if params[:search]
      p = params[:search].dup
    else
      p = []
    end
    @results = Profile.search((p.delete(:q) || ''), p).paginate(:page => @page, :per_page => @per_page)
  end
end
