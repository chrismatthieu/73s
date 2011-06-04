class ListsController < ApplicationController

  skip_filter :login_required, :only => [:index, :gear, :callsign]
  before_filter :setup

  # GET /lists
  # GET /lists.xml
  def index
    
    if !@p.nil? 
      @profile = @p
      @want = List.find(:all, :conditions => ['user_id = ? and status = ?', @p.id, 1])
      @have = List.find(:all, :conditions => ['user_id = ? and status = ?', @p.id, 2])
      @had = List.find(:all, :conditions => ['user_id = ? and status = ?', @p.id, 3])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lists }
    end
  end
  
  def widget
    # if !@p.nil? 
    #   @profile = @p
    #   @want = List.find(:all, :conditions => ['user_id = ? and status = ?', @userx.profile.user_id, 1])
    #   @have = List.find(:all, :conditions => ['user_id = ? and status = ?', @profile.user_id, 2])
    #   @had = List.find(:all, :conditions => ['user_id = ? and status = ?', @profile.user_id, 3])
    # end
  end

  # GET /lists/1
  # GET /lists/1.xml
  def show
    @list = List.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @list }
    end
  end

  # GET /lists/new
  # GET /lists/new.xml
  def new
    @list = List.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @list }
    end
  end

  # GET /lists/1/edit
  def edit
    @list = List.find(params[:id])
  end

  # POST /lists
  # POST /lists.xml
  def create
    
    @onfile = List.find(:first, :conditions => ['user_id = ? and product_id = ?', @p.id, params[:list][:product_id]])
    
    if @onfile
      # @list.user_id = @p.id
      @onfile.update_attributes(params[:list])
    else
      @list = List.new(params[:list])
      @list.user_id = @p.id
      @list.save
    end

    respond_to do |format|
      if true
        flash[:notice] = 'List was successfully updated.'
        format.html { redirect_to(@list) }
        format.xml  { render :xml => @list, :status => :created, :location => @list }
        format.js {
           render :update do |page|
             # page.call "RedBox.close"
             page.alert "List Updated!"
             # page.visual_effect :highlight, 'list_action', :duration => 3
                      # page[:list_action].replace_html "Updated!"
                   end
         
          # page["list_action"].replace_html "Updated!"
          # page["list_action"].visual_effect :highlight
          # page.insert_html :top, :text=&gt;'update!'
          # page[:list_action].text="Updated!"

          # page.insert_html :bottom, 'list_action', "updated!"
          # page.visual_effect :highlight, 'list_action',
          #   :duration => 3

          
          # render :text => "Updated!"
          }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /lists/1
  # PUT /lists/1.xml
  def update
    @list = List.find(params[:id])

    respond_to do |format|
      if @list.update_attributes(params[:list])
        flash[:notice] = 'List was successfully updated.'
        format.html { redirect_to(@list) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /lists/1
  # DELETE /lists/1.xml
  def destroy
    @list = List.find(params[:id])
    @list.destroy

    respond_to do |format|
      format.html { redirect_to(lists_url) }
      format.xml  { head :ok }
    end
  end
  
  def callsign
    @callsign = params[:callsign]
  
    # @user = User.find_by_login(@callsign) 
    # @userx = User.find(:first, :conditions => ['login = ?', @callsign])
    # @userx = User.find(:first, :conditions => ['login ILIKE ?', @callsign])           
    if request.url.index('localhost')
      @userx = User.find(:first, :conditions => ['login LIKE ?', @callsign])         
    else
      @userx = User.find(:first, :conditions => ['login ILIKE ?', @callsign])         
    end
    
  
    if @userx
      @profile = @userx.profile
      if !@profile.nil? 
        @want = List.find(:all, :conditions => ['user_id = ? and status = ?', @profile.id, 1])
        @have = List.find(:all, :conditions => ['user_id = ? and status = ?', @profile.id, 2])
        @had = List.find(:all, :conditions => ['user_id = ? and status = ?', @profile.id, 3])
      end      
      
      if params[:mode] == "gear"
        render :action => 'index'
      else
        render :action => 'widget', :layout=>false
      end  
    
    else
      redirect_to(:controller => 'home', :action => 'callsign', :id => @callsign)
    end
  end
  
  
  private

  def allow_to 
    #super :all, :only => [:index, :show, :callsign]
    super :all, :all=>true
  end
  
  def setup
  end
  
end
