class ProductsController < ApplicationController

  skip_filter :login_required, :only => [:index, :show]
  before_filter :setup

  # GET /products
  # GET /products.xml
  def index
    # @products = Product.all
    if params[:company_id].nil?
      
      @products = Product.paginate(:all, 
      :order => "name asc", 
      :per_page => 10,
      :page => params[:page])

    else
      
      @company = Company.find(params[:company_id])
      @products = Product.paginate(:all, 
      :order => "name asc", 
      :conditions => ['company_id = ?', params[:company_id]],
      :per_page => 10,
      :page => params[:page])

    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @products }
    end
  end

  # GET /products/1
  # GET /products/1.xml
  def show

    @product = Product.find(params[:id])
    @company = @product.company
    
    @reviewid = @product.id
    
    @getrating = Rating.find(:all, :conditions => [ "controllername = ? and controllerid = ?", "products", @reviewid])
    if @getrating.nil?
      @rating=0
    else
      average = 0.0
      counter = 0
      @getrating.each { |r|
        average = average + r.rating
        counter = counter + 1
      }
      if counter != 0
        average = average / counter 
      end
      @rating = average    
    end     
    

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/new
  # GET /products/new.xml
  def new
    @product = Product.new
    @company = params[:company_id]
    
    # @reviewid = @review.id
    # 
    # 
    # @getrating = Rating.find(:all, :conditions => [ "controllername = ? and controllerid = ?", "products", @review.id])
    # if @getrating.nil?
    #   @rating=0
    # else
    #   average = 0.0
    #   counter = 0
    #   @getrating.each { |r|
    #     average = average + r.rating
    #     counter = counter + 1
    #   }
    #   if counter != 0
    #     average = average / counter 
    #   end
    #   @rating = average    
    # end
    

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
    @company = @product.company
  end

  # POST /products
  # POST /products.xml
  def create
    @product = Product.new(params[:product])

    @forum = Forum.new
    @forum.title = params[:product][:name]
    @forum.save

    @product.forum_id = @forum.id
    
    respond_to do |format|
      if @product.save
        
              
        @twitusername = @p.twitter_name
        if @twitusername == nil || !@p.twitter_pass.blank?
          @twituser = ""
        else
          @twituser = " (@#{@twitusername})"
        end
        
        @tweet = @p.user.login + @twituser + " added new product - http://73s.org/products/" + @product.id.to_s
        twitter(@tweet)
        
        
        flash[:notice] = 'Product was successfully created.'
        format.html { redirect_to('/products/' + @product.id.to_s) }
        format.xml  { render :xml => @product, :status => :created, :location => @product }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.xml
  def update
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:product])
        flash[:notice] = 'Product was successfully updated.'
        format.html { redirect_to('/products/' + @product.id.to_s) }
        format.xml  { head :ok }
      else
        flash[:notice] = 'Error encountered on update.'
        format.html { redirect_to('/products/' + @product.id.to_s) }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.xml
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to(products_url) }
      format.xml  { head :ok }
    end
  end

  def rate
    #@rating = Rating.find(params[:id])
    #Rating.delete_all(["rateable_type = 'Beers' AND rateable_id = ? AND user_id = ?", @asset.id, current_user.id])
    #@beer.add_rating Rating.new(:rating => params[:rating], :user_id => current_user.id)

    @killrating = Rating.find(:first, :conditions => [ "profile_id = ? and controllername = ? and controllerid = ?", @p.id, "products", params[:id]])
    if @killrating != nil
      @killrating.destroy
    end

    @newrating = Rating.new
    @newrating.profile_id = @p.id
    @newrating.controllername = "products"
    @newrating.controllerid = params[:id]
    @newrating.rating = params[:rating]

    @reviewid = params[:id]    

    if @newrating.save

      #@getrating = Rating.find(:first, :conditions => [ "chugger_id = ? and controllername = ? and controllerid = ?", session[:member_id], "beers", params[:id]])
      #if @getrating.nil?
      #  @rating=0
      #else
      #  @rating = @getrating.rating  
      #end 

      @getrating = Rating.find(:all, :conditions => [ "controllername = ? and controllerid = ?", "products", @reviewid])
      if @getrating.nil?
        @rating=0
      else
        average = 0.0
        counter = 0
        @getrating.each { |r|
          average = average + r.rating
          counter = counter + 1
        }
        if counter != 0
          average = average / counter 
        end
        @rating = average    
      end      
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
