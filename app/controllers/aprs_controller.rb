class AprsController < ApplicationController
  skip_filter :login_required, :only => [:callsign, :index, :aprsfeed]
  
  def callsign
    @callsign = params[:callsign]
  
    #@user = User.find_by_login(@callsign) 
    # @user = User.find(:first, :conditions => ['login = ?', @callsign])
    if request.url.index('localhost')
      @user = User.find(:first, :conditions => ['login LIKE ?', @callsign])           
    else
       @user = User.find(:first, :conditions => ['login ILIKE ?', @callsign])           
    end
    
  
    # if @user
      
      render :action => 'index'
    
    # else
    #   redirect_to(:controller => 'home', :action => 'callsign', :id => @callsign)
    # end
  end
  
  def aprsfeed
    
  end

  protected

  def allow_to
    super :owner, :all => true
    super :all, :only => [:index, :callsign, :aprsfeed]
  end


end


