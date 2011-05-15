class AdvertsController < ApplicationController
  skip_filter :login_required, :only => [:banner, :redir]
  # before_filter :setup, :except => [:banner]


  # GET /adverts
  # GET /adverts.xml
  def index
    #@adverts = Advert.find(:all)
    @adverts = Advert.paginate(:all, :order => 'startdate ASC', 
    :per_page => 10,
    :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @adverts }
    end
  end

  # GET /adverts/1
  # GET /adverts/1.xml
  def show
    @advert = Advert.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @advert }
    end
  end

  # GET /adverts/new
  # GET /adverts/new.xml
  def new
    @advert = Advert.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @advert }
    end
  end

  # GET /adverts/1/edit
  def edit
    @advert = Advert.find(params[:id])
  end

  # POST /adverts
  # POST /adverts.xml
  def create
    @advert = Advert.new(params[:advert])
    @advert.profile_id = @p.id
    @advert.viewcount = 0

    respond_to do |format|
      if @advert.save
        flash[:notice] = 'Advert was successfully created.'
        format.html { redirect_to('/adverts') }
        format.xml  { render :xml => @advert, :status => :created, :location => @advert }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @advert.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /adverts/1
  # PUT /adverts/1.xml
  def update
    @advert = Advert.find(params[:id])

    respond_to do |format|
      if @advert.update_attributes(params[:advert])
        flash[:notice] = 'Advert was successfully updated.'
        format.html { redirect_to('/adverts') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @advert.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /adverts/1
  # DELETE /adverts/1.xml
  def destroy
    @advert = Advert.find(params[:id])
    @advert.destroy

    respond_to do |format|
      format.html { redirect_to(adverts_url) }
      format.xml  { head :ok }
    end
  end

  def save 

    @advert = Advert.find(params[:advert][:id])

    if @advert == nil || @advert == ''
      render(:action => :index) 
    else
      if @advert.update_attributes(params[:advert])
        redirect_to(:action => 'show', :id => @advert.id) 
      else 
        render(:action => :upload) 
      end 
    end 
    
  end 

  def banner 
    #View specific picture by adverts/banner/123
    @advert = Advert.find(params[:id]) 
    send_data(@advert.data, 
    :filename => "#{@advert.name}", 
    :type => @advert.content_type, 
    :disposition => "inline") 
  end  
  
  def redir
    @advert = Advert.find(params[:id])
    if @advert.clickcount.nil?
      @clicks = 1
    else  
      @clicks = @advert.clickcount + 1
    end
    if @advert.update_attributes(:clickcount => @clicks)
      redirect_to @advert.url
    end
  end

  def allow_to
    super :owner, :all => true
    super :user, :all => true
    super :all, :only => [:banner, :redir]
  end
  

end
