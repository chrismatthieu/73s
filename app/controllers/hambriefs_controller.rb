class HambriefsController < ApplicationController
  skip_filter :login_required, :only => [:index, :show]
  before_filter :setup

  # GET /hambriefs
  # GET /hambriefs.xml
  def index
    #@hambriefs = Hambrief.find(:all)
    @hambriefs = Hambrief.paginate(:order => 'created_at  DESC', 
    :per_page => 2,
    :page => params[:page])
    

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @hambriefs }
    end
  end

  # GET /hambriefs/1
  # GET /hambriefs/1.xml
  def show
    @hambrief = Hambrief.find(:first, :conditions => ['episode = ?', params[:id]])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @hambrief }
    end
  end

  # GET /hambriefs/new
  # GET /hambriefs/new.xml
  def new
    @hambrief = Hambrief.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @hambrief }
    end
  end

  # GET /hambriefs/1/edit
  def edit
    @hambrief = Hambrief.find(params[:id])
  end

  # POST /hambriefs
  # POST /hambriefs.xml
  def create
    @hambrief = Hambrief.new(params[:hambrief])

    respond_to do |format|
      if @hambrief.save
        flash[:notice] = 'Hambrief was successfully created.'
        format.html { redirect_to('/') }
        format.xml  { render :xml => @hambrief, :status => :created, :location => @hambrief }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @hambrief.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /hambriefs/1
  # PUT /hambriefs/1.xml
  def update
    @hambrief = Hambrief.find(params[:id])

    respond_to do |format|
      if @hambrief.update_attributes(params[:hambrief])
        flash[:notice] = 'Hambrief was successfully updated.'
        format.html { redirect_to('/') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @hambrief.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /hambriefs/1
  # DELETE /hambriefs/1.xml
  def destroy
    @hambrief = Hambrief.find(params[:id])
    @hambrief.destroy

    respond_to do |format|
      format.html { redirect_to(hambriefs_url) }
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
