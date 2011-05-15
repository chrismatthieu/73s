class GroupersController < ApplicationController
  skip_filter :login_required, :only => [:create, :destroy]
    
  # GET /groupers
  # GET /groupers.xml
  def index
    @groupers = Grouper.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groupers }
    end
  end

  # GET /groupers/1
  # GET /groupers/1.xml
  def show
    @grouper = Grouper.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @grouper }
    end
  end

  # GET /groupers/new
  # GET /groupers/new.xml
  def new
    @grouper = Grouper.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @grouper }
    end
  end

  # GET /groupers/1/edit
  def edit
    @grouper = Grouper.find(params[:id])
  end

  # POST /groupers
  # POST /groupers.xml
  def create
    @grouper = Grouper.new(params[:grouper])
    @grouper.profile_id = @p.id
    @grouper.group_id = params[:id]

    respond_to do |format|
      if @grouper.save
        flash[:notice] = 'Joined group successfully.'
        
        @twitusername = @p.twitter_name
        if @twitusername == nil || !@p.twitter_pass.blank?
          @twituser = ""
        else
          @twituser = " (@#{@twitusername})"
        end
        
        @tweet = @p.user.login + @twituser + " joined #{@grouper.group.title} group - http://73s.org/groups/#{@grouper.group_id}"
        twitter(@tweet)
        
        format.html { render :text => "Joined Group" }
        format.xml  { render :xml => @grouper, :status => :created, :location => @grouper }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @grouper.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /groupers/1
  # PUT /groupers/1.xml
  def update
    @grouper = Grouper.find(params[:id])

    respond_to do |format|
      if @grouper.update_attributes(params[:grouper])
        flash[:notice] = 'Grouper was successfully updated.'
        format.html { redirect_to('/') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @grouper.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /groupers/1
  # DELETE /groupers/1.xml
  def destroy
    #@grouper = Grouper.find(params[:id])
    @grouper = Grouper.find(:first, :conditions => ["profile_id = ? and group_id = ?", @p.id, params[:id]])
    @grouper.destroy

    respond_to do |format|
      format.html { render :text => "Left Group" }
      format.xml  { head :ok }
    end
  end
  
  protected
  
  
  def allow_to
    super :owner, :all => true
    super :user, :all => true
    super :all, :only => [:create, :destroy]
  end
  
end
