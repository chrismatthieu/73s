class TimelineController < ApplicationController

  skip_filter :login_required, :only => [:index, :show]
  
  def user
    if params[:id] == 'default'
      @userid = session[:member_id]
    else
      @userid = params[:id]
    end
    
    # @userid = params[:id]
  end

  def user2
    @userid = params[:id]
    render :layout => false
  end

  def show
    @contacts = Contact.find(:all, :conditions => ["profile_id = ?", params[:id]])
    respond_to do |wants|
      wants.html {render}
      wants.xml {render :layout => false}
    end
    #render :layout => false
    
  end
  
  def callsign
    @callsign = params[:callsign]
  
    #@user = User.find_by_login(@callsign) 
    # @user = User.find(:first, :conditions => ['login = ?', @callsign])
    @user = User.find(:first, :conditions => ['login ILIKE ?', @callsign])            
    
  
    if @user

      params[:id] = @user.profile.id

      #show
      #index
      @contacts = Contact.find(:all, :conditions => ["profile_id = ?", params[:id]])
      
      respond_to do |wants|
        wants.html {render :action => 'user'}
        wants.xml {render :layout => false}
      end
      #render :action => 'user'
    
    else
      redirect_to(:controller => 'home', :action => 'callsign', :id => @callsign)
    end
  end
  
  protected

  def allow_to
    super :owner, :all => true
    super :user, :all => true
    super :all, :only => [:index, :show]
  end
  
end
