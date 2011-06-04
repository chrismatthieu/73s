class PhotosController < ApplicationController
  skip_filter :login_required, :only => [:callsign, :index]
  before_filter :setup, :except => [:callsign]
  
  
  
  def index
    respond_to do |wants|
      wants.html {render}
      wants.rss {render :layout=>false}
      wants.iphone {render}
    end
  end
  
  def show
    redirect_to profile_photos_path(@profile)
  end
  
  
  def create
    @photo = @p.photos.build params[:photo]
    
    respond_to do |wants|
      if @photo.save
        wants.html do
          flash[:notice] = 'Photo successfully uploaded.'
          
          @twitusername = @p.twitter_name
          if @twitusername == nil || !@p.twitter_pass.blank?
            @twituser = ""
          else
            @twituser = " (@#{@twitusername})"
          end
          
          @tweet = @p.user.login + @twituser + " uploaded new photo - " + "http://73s.org/" + @p.user.login + "/photos"
          twitter(@tweet)
          
          redirect_to profile_photos_path(@p)
        end
      else
        wants.html do
          flash.now[:error] = 'Photo could not be uploaded.'
          render :action => :index
        end
      end
    end
  end
  
  
  def callsign
    @callsign = params[:callsign]
  
    #@user = User.find_by_login(@callsign) 
    # @userx = User.find(:first, :conditions => ['login = ?', @callsign])
    # @userx = User.find(:first, :conditions => ['login ILIKE ?', @callsign])    
    if request.url.index('localhost')
      @userx = User.find(:first, :conditions => ['login LIKE ?', @callsign])         
    else
      @userx = User.find(:first, :conditions => ['login ILIKE ?', @callsign])         
    end
  
    if @userx

      params[:profile_id] = @userx.profile.id

      setup
      
      #index
      
      render :action => 'index'
    
    else
      redirect_to(:controller => 'home', :action => 'callsign', :id => @callsign)
    end
  end
  
  
  def destroy
    Photo[params[:id]].destroy
    respond_to do |wants|
      wants.html do
        flash[:notice] = 'Photo was deleted.'
        redirect_to profile_photos_path(@p)
      end
    end
  end
  
  
  
  private
  
  def allow_to
    super :owner, :all => true
    super :all, :only => [:index, :show, :callsign]
  end
  
  
  def setup
    @profile = Profile[params[:profile_id] || params[:id]]
    @user = @profile.user
    @photos = @profile.photos.paginate(:all, :page => @page, :per_page => @per_page)
    @photo = Photo.new
  end
end
