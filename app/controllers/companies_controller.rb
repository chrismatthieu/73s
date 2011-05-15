class CompaniesController < ApplicationController

  skip_filter :login_required, :only => [:index]
  before_filter :setup
  # in_place_edit_for :index, 'company'

  # GET /companies
  # GET /companies.xml
  def index
    # @companies = Company.all
    @companies = Company.paginate(:all, 
    :order => "name asc", 
    :per_page => 10,
    :page => params[:page])
    

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @companies }
    end
  end
  
  def search
    
    name1 = params[:id]
    ascii = name1.unpack("C*")
    # We can't use Array#each since we can't mutate a Fixnum
    ascii.collect! { |i|
        i + 1                         # add one to each ASCII value
    }                
    name2 = ascii.pack("C*")
    
    @companies = Company.paginate(:all, 
    :conditions => ["name > ? and name < ?", name1, name2],
    :order => "name asc", 
    :per_page => 10,
    :page => params[:page])
    

    respond_to do |format|
      format.html { render :action => 'index' }
      format.xml  { render :xml => @companies }
    end
  end

  # GET /companies/1
  # GET /companies/1.xml
  def show
    @company = Company.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @company }
    end
  end

  # GET /companies/new
  # GET /companies/new.xml
  def new
    @company = Company.new    

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @company }
    end
  end

  # GET /companies/1/edit
  def edit
    @company = Company.find(params[:id])
  end

  # POST /companies
  # POST /companies.xml
  def create
    @company = Company.new(params[:company])

    respond_to do |format|
      if @company.save
        flash[:notice] = 'Company was successfully created.'
        format.html { redirect_to(@company) }
        format.xml  { render :xml => @company, :status => :created, :location => @company }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /companies/1
  # PUT /companies/1.xml
  def update
    @company = Company.find(params[:id])

    respond_to do |format|
      if @company.update_attributes(params[:company])
        flash[:notice] = 'Company was successfully updated.'
        format.html { redirect_to('/companies/' + @company.id.to_s)  }
        format.xml  { head :ok }
      else
        flash[:notice] = 'Error encountered on update.'
        format.html { redirect_to('/companies/' + @company.id.to_s) }
        format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.xml
  def destroy
    @company = Company.find(params[:id])
    @company.destroy

    respond_to do |format|
      format.html { redirect_to(companies_url) }
      format.xml  { head :ok }
    end
  end
  
  def updatedescription
    # @target  = params[:value]
    # @user = User.find(params[:id])
    # # 
    # # @user.status = @target
    # # @user.last_active = Time.now
    # # @user.save
    # 
    # @status = Status.new()
    # @status.profile_id = params[:id]
    # @status.message = @target
    # @status.save
    # 
    # @twitusername = @user.profile.twitter_name
    # if @twitusername == nil
    #   @twituser = ""
    # else
    #   @twituser = " (@#{@twitusername})"
    # end
    # 
    # @tweet = @user.login + @twituser + " status - " + @target + " - http://73s.org/" + @user.login 
    # twitter(@tweet) rescue ""
    # 
    # @status = Status.find(:all, :conditions => ['profile_id = ?', params[:id]], :order => 'created_at DESC', :limit => 1)
    # 
    # render :text => @target do |page|
    #   page.insert_html :top, :statustweets, :partial => "statuslist"
    # end
    # #render :text => @target
  end
  
  
  private

  def allow_to 
    #super :all, :only => [:index, :show, :callsign]
    super :all, :all=>true
  end
  
  def setup
  end
  
end
