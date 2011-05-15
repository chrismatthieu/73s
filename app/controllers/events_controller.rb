class EventsController < ApplicationController

  skip_filter :login_required, :only => [:index, :show]
  before_filter :setup

  # GET /events
  # GET /events.xml
  def index
    #@events = Event.find(:all)
    
    # script/plugin install http://topfunky.net/svn/plugins/calendar_helper/
    
    if params[:month] != nil && params[:year] != nil
      @eyear = params[:year].to_i
      @emonth = params[:month].to_i
    
    else
      t= Time.now
      @eyear = t.year
      @emonth = t.mon
      
    end
    
    #range = "created_at #{(12.months.ago.to_date..Date.today).to_s(:db)}"
    #@users = User.count(:all, :conditions => range, :group => "DATE_FORMAT(created_at, '%Y-%m')", :order =>"created_at ASC")
    #foo BETWEEN ? AND ?", 1, 5
    
    @events = Event.paginate(:order => 'eventdate ASC', 
    :conditions => ["eventdate between ? and ?", @eyear.to_s + '/' + @emonth.to_s + '/1', @eyear.to_s + '/' + @emonth.to_s + '/31' ],
    :per_page => 10,
    :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
      format.iphone # index.html.erb
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
      format.iphone # index.html.erb
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])
    
    #Add logic to handle country codes
    #http://blog.whitet.net/articles/2007/12/17/country-codes-rails-plugin
    @country = CountryCodes.find_a2_by_name(@event.eventcountry)
    @event.eventcountry = @country
    
    @event.profile_id = @p.id
    

    respond_to do |format|
      if @event.save
        flash[:notice] = 'Event was successfully created.'
        
        @twitusername = @p.twitter_name
        if @twitusername == nil || !@p.twitter_pass.blank?
          @twituser = ""
        else
          @twituser = " (@#{@twitusername})"
        end
        
        @tweet = @p.user.login + @twituser + " added new event entry - " + "http://73s.org/events"
        twitter(@tweet) rescue ""
        
        format.html { redirect_to(events_url) }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        flash[:notice] = 'Event was successfully updated.'
        format.html { redirect_to('/events') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
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
    super :all, :only => [:index, :show]
  end
  
end
