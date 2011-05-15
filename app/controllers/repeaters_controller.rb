class RepeatersController < ApplicationController

  skip_filter :login_required, :only => [:index, :show, :search]
  before_filter :setup

  # GET /repeaters
  # GET /repeaters.xml
  def index
    #@repeaters = Repeater.find(:all)
    #@repeaters = Repeater.paginate(:order => 'state ASC', 
    #:per_page => 10,
    #:page => params[:page])

    #@repeaters = Repeater.find(:all, :select => [:city], :group => "city")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @repeaters }
      format.iphone # index.html.erb
    end
  end

  # GET /repeaters/1
  # GET /repeaters/1.xml
  def show
      
    @repeater = Repeater.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @repeater }
      format.iphone # index.html.erb
    end
  end

  # GET /repeaters/new
  # GET /repeaters/new.xml
  def new
    @repeater = Repeater.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @repeater }
    end
  end

  # GET /repeaters/1/edit
  def edit
    @repeater = Repeater.find(params[:id])
  end

  # POST /repeaters
  # POST /repeaters.xml
  def create
    @repeater = Repeater.new(params[:repeater])

    respond_to do |format|
      if @repeater.save
        flash[:notice] = 'Repeater was successfully created.'
        
        @twitusername = @p.twitter_name
        if @twitusername == nil || !@p.twitter_pass.blank?
          @twituser = ""
        else
          @twituser = " (@#{@twitusername})"
        end
        
        @tweet = @p.user.login + @twituser + " posted new repeater entry - " + "http://73s.org/repeaters"
        twitter(@tweet)
        
        format.html { redirect_to('/repeaters') }
        format.xml  { render :xml => @repeater, :status => :created, :location => @repeater }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @repeater.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /repeaters/1
  # PUT /repeaters/1.xml
  def update
    @repeater = Repeater.find(params[:id])

    respond_to do |format|
      if @repeater.update_attributes(params[:repeater])
        flash[:notice] = 'Repeater was successfully updated.'
        format.html { redirect_to('/repeaters') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @repeater.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /repeaters/1
  # DELETE /repeaters/1.xml
  def destroy
    @repeater = Repeater.find(params[:id])
    @repeater.destroy

    respond_to do |format|
      format.html { redirect_to(repeaters_url) }
      format.xml  { head :ok }
    end
  end
  
  def search
    #@repeaters = Repeater.find(:all)
    if params[:page] == nil
      @city = params[:repeaters][:city]
      session[:city] = @city
    else
      @city = session[:city]
    end
    
    @repeaters = Repeater.paginate(:conditions => ["city = ?", @city], 
    :order => 'frequency ASC', 
    :per_page => 10,
    :page => params[:page])
    
    respond_to do |format|
      format.html # search.html.erb
      format.xml  { render :xml => @repeaters }
      format.iphone # index.html.erb
    end
  end
  
  protected
  
  def setup
  end
  
  
  
  def allow_to
    super :owner, :all => true
    super :user, :all => true
    super :all, :only => [:index, :show, :search]
  end
  
end
