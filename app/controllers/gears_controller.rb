class GearsController < ApplicationController

  skip_filter :login_required, :only => [:index, :show]
  before_filter :setup


  # GET /gears
  # GET /gears.xml
  def index
    #@gears = Gear.find(:all)

    @gears = Gear.paginate(:order => 'created_at DESC', 
    :per_page => 10,
    :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @gears }
    end
  end

  # GET /gears/1
  # GET /gears/1.xml
  def show
    @gear = Gear.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @gear }
    end
  end

  # GET /gears/new
  # GET /gears/new.xml
  def new
    @gear = Gear.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @gear }
    end
  end

  # GET /gears/1/edit
  def edit
    @gear = Gear.find(params[:id])
  end

  # POST /gears
  # POST /gears.xml
  def create
    @gear = Gear.new(params[:gear])
    @gear.profile_id = @p.id
    @gear.forsale = true
    @gear.active = true
    

    respond_to do |format|
      if @gear.save
        flash[:notice] = 'Gear was successfully created.'
        
        
        @twitusername = @p.twitter_name
        if @twitusername == nil || !@p.twitter_pass.blank?
          @twituser = ""
        else
          @twituser = " (@#{@twitusername})"
        end
        
        @tweet = @p.user.login + @twituser + " added new ham gear for sale - " + "http://73s.org/gears"
        twitter(@tweet)
        
        
        
        format.html { redirect_to('/gears') }
        format.xml  { render :xml => @gear, :status => :created, :location => @gear }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @gear.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /gears/1
  # PUT /gears/1.xml
  def update
    @gear = Gear.find(params[:id])

    respond_to do |format|
      if @gear.update_attributes(params[:gear])
        flash[:notice] = 'Gear was successfully updated.'
        format.html { redirect_to('/gears') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @gear.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /gears/1
  # DELETE /gears/1.xml
  def destroy
    @gear = Gear.find(params[:id])
    @gear.destroy

    respond_to do |format|
      format.html { redirect_to(gears_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
  
  def setup
  end
  
  
  
  def allow_to
    super :owner, :all => true
    super :user, :all => true
    super :all, :only => [:index, :show]
  end
  
  
end
