class GroupsController < ApplicationController

  skip_filter :login_required, :only => [:index, :show]
  # before_filter :login_required, :except => :confirm
  
  # GET /groups
  # GET /groups.xml
  def index
    @groups = Group.paginate(:order => 'title ASC', 
    :per_page => 10,
    :page => params[:page])

    @group = Group.new

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.xml
  def show
    @group = Group.find(params[:id])
    @members = Grouper.find(:all, :conditions => ["group_id = ?", params[:id]])
    
    @forum = Forum.find_by_title("#{@group.title}")
    @topics = @forum.topics.paginate :page => params[:page] rescue nil  

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.xml
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groups
  # POST /groups.xml
  def create
    @group = Group.new(params[:group])
    
    @group.profile_id = @p.id

    respond_to do |format|
      if @group.save
        
        @forum = Forum.new
        @forum.title = params[:group][:title]
        @forum.save
        
        flash[:notice] = 'Group was successfully created.'
        
        @twitusername = @p.twitter_name
        if @twitusername == nil || !@p.twitter_pass.blank?
          @twituser = ""
        else
          @twituser = " (@#{@twitusername})"
        end
        
        @tweet = @p.user.login + @twituser + " created new group - http://73s.org/groups"
        twitter(@tweet)
        
        format.html { redirect_to('/groups') }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.xml
  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        flash[:notice] = 'Group was successfully updated.'
        format.html { redirect_to('/groups') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.xml
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to(groups_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
  
  
  def allow_to
    super :owner, :all => true
    super :user, :all => true
    super :all, :only => [:index, :show]
  end
  
end
