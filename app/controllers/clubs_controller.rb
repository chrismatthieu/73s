class ClubsController < ApplicationController
  
  skip_filter :login_required, :only => [:index, :show, :state_select]
  before_filter :setup
  
  # GET /clubs
  # GET /clubs.xml
  def index
    #@clubs = Club.find(:all)
    
    @clubs = Club.paginate(:order => 'clubname ASC', 
    :per_page => 10,
    :page => params[:page])
    

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @clubs }
      format.iphone # index.html.erb
    end
  end

  # GET /clubs/1
  # GET /clubs/1.xml
  def show
    @club = Club.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @club }
      format.iphone # index.html.erb
    end
  end

  # GET /clubs/new
  # GET /clubs/new.xml
  def new
    @club = Club.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @club }
    end
  end

  # GET /clubs/1/edit
  def edit
    @club = Club.find(params[:id])
  end

  # POST /clubs
  # POST /clubs.xml
  def create
    @club = Club.new(params[:club])
    
    #Add logic to handle country codes
    #http://blog.whitet.net/articles/2007/12/17/country-codes-rails-plugin
    @country = CountryCodes.find_a2_by_name(@club.clubcountry)
    @club.clubcountry = @country
    
    @club.profile_id = @p.id
    

    respond_to do |format|
      if @club.save
        flash[:notice] = 'Club was successfully created.'
        
        @twitusername = @p.twitter_name
        if @twitusername == nil || !@p.twitter_pass.blank?
          @twituser = ""
        else
          @twituser = " (@#{@twitusername})"
        end
        
        @tweet = @p.user.login + @twituser + " added new club entry - http://73s.org/clubs"
        twitter(@tweet) rescue ""
        
        format.html { redirect_to('/clubs') }
        format.xml  { render :xml => @club, :status => :created, :location => @club }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @club.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /clubs/1
  # PUT /clubs/1.xml
  def update
    @club = Club.find(params[:id])

    respond_to do |format|
      if @club.update_attributes(params[:club])
        flash[:notice] = 'Club was successfully updated.'
        format.html { redirect_to('/clubs') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @club.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /clubs/1
  # DELETE /clubs/1.xml
  def destroy
    @club = Club.find(params[:id])
    @club.destroy

    respond_to do |format|
      format.html { redirect_to(clubs_url) }
      format.xml  { head :ok }
    end
  end
  
  def state_select
    render :layout => false
  end
  
  protected
  
  def setup
  end
  
  
  
  def allow_to
    super :owner, :all => true
    super :user, :all => true
    super :all, :only => [:index, :show, :state_select]
  end
  
end
