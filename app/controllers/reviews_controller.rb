class ReviewsController < ApplicationController
  
    #before_filter :check_for_login, :only => [ :new, :create, :edit, :delete ]
  skip_filter :login_required, :only => [:index, :show]
    
  
  def index
    all
    render :action => 'all'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list

  #  @comment_pages, @comments = paginate :comments, :order => 'timestamp ASC', :per_page => 5, :conditions => [ "controllername = ? and controllerid = ?", 'reviews', params[:id]]
    @reviews = Review.paginate(:order => 'timestamp DESC', 
    :per_page => 5,
    :page => params[:page])
  
  end

  def all
    #@review_pages, @reviews = paginate :reviews, :order => 'timestamp DESC', :per_page => 5    
    @reviews = Review.paginate(:order => 'timestamp DESC', 
    :per_page => 5,
    :page => params[:page])
    @revs = Review.count
  end

  def popular
    #@review_pages, @reviews = paginate :reviews, :order => 'viewcount DESC', :per_page => 5
    @reviews = Review.paginate(:order => 'viewcount DESC', 
    :per_page => 5,
    :page => params[:page])
    @revs = Review.count
  end

  def best
    #@review_pages, @reviews = paginate :reviews, :order => 'thumbsup DESC', :per_page => 5
    @reviews = Review.paginate(:order => 'thumbsup DESC', 
    :per_page => 5,
    :page => params[:page])
    @revs = Review.count
  end

  def worst
    #@review_pages, @reviews = paginate :reviews, :order => 'thumbsdown DESC', :per_page => 5
    @reviews = Review.paginate(:order => 'thumbsdown DESC', 
    :per_page => 5,
    :page => params[:page])
    @revs = Review.count
  end

  def show
    @review = Review.find(params[:id])
    @user = @review.profile.user
    @revid = params[:id]
    @reviewid = @review.id
    
    # update view counter for most popular
    @views = @review.viewcount + 1
    @review.update_attributes(:viewcount => @views)
    
    @getrating = Rating.find(:all, :conditions => [ "controllername = ? and controllerid = ?", "reviews", @reviewid])
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

  def new
    @review = Review.new
    @reviewid = @review.id
    
    
    @getrating = Rating.find(:all, :conditions => [ "controllername = ? and controllerid = ?", "reviews", @review.id])
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

  def create
    @review = Review.new(params[:review])
    @review.profile_id = @p.id
    @review.timestamp = Time.now()
    @review.thumbsup = 0
    @review.thumbsdown = 0
    @review.viewcount = 0
    if @review.save
      
      #http://wiki.rubyonrails.org/rails/pages/ActsAsTaggablePluginHowto
#      @review.tag_with(params[:tags])
      
      
      #Update user rating of candidate by review
      #@candidateid = params[:review][:candidate_id]
      #@killrating = Rating.find(:first, :conditions => [ "user_id = ? and controllername = ? and controllerid = ?", current_user.id, "candidates", @candidateid])
      #if @killrating !=nil
      #  @killrating.destroy
      #end

      #@newrating = Rating.new
      #@newrating.user_id = current_user.id
      #@newrating.controllername = "reviews"
      #@newrating.controllerid = 1
      #@newrating.rating = params[:review][:rating]
      #@newrating.save
      
      #Update candidate's average rating from all reviews
      #@getrating = Rating.find(:all, :conditions => [ "controllername = ? and controllerid = ?", "candidates", @candidateid])
      #if @getrating.nil?
      #  @rating=0
      #else
      #  average = 0.0
      #  counter = 0
      #  @getrating.each { |r|
      #    average = average + r.rating
      #    counter = counter + 1
      #  }
      #  if counter != 0
      #    average = average / counter 
      #  end
      #  @rating = average    
      #end     
      #@candidateupdate = Candidate.find(@candidateid)
      #@candidateupdate.rating = @rating
      #@candidateupdate.save
      
      #Return results to user
      
      
      flash[:notice] = 'Review was successfully created.'
      
      @twitusername = @p.twitter_name
      if @twitusername == nil || !@p.twitter_pass.blank?
        @twituser = ""
      else
        @twituser = " (@#{@twitusername})"
      end
      
      @tweet = @p.user.login + @twituser + " posted new QST - " + "http://73s.org/reviews"
      twitter(@tweet)
      
      
      # redirect_to :controller => 'reviews', :action => 'show', :id => @review
      redirect_to '/'

    else
      render :action => 'new'
    end
  end

  def edit
    @review = Review.find(params[:id])
  end

  def update
    @review = Review.find(params[:id])
    if @review.update_attributes(params[:review])
      
      #http://wiki.rubyonrails.org/rails/pages/ActsAsTaggablePluginHowto
      #@review.tag_with(params[:tags])
      
      
      flash[:notice] = 'Review was successfully updated.'
      redirect_to :action => 'show', :id => @review
    else
      render :action => 'edit'
    end
  end

  def destroy
    Review.find(params[:id]).destroy
    redirect_to :controller => 'reviews'
  end

def destroycomment
  if @p.id == nil 
    redirect_to :controller => 'reviews' 
  else    
    Comment.find(params[:id]).destroy
    redirect_to :controller => 'reviews'
  end
end

def postcomment
  @comment = Comment.new(params[:comment])
  @comment.profile_id = @p.id
  @comment.controllername = "reviews"
  @comment.controllerid = params[:comment][:controllerid]
  @comment.timestamp = Time.now()    
  if @comment.save
    flash[:notice] = 'Comment was successfully created.'
    # redirect_to :action => 'show', :id =>  @comment.controllerid
    @revid = params[:comment][:controllerid]
    
    # if review requests emails on comment then send email
    @review = Review.find(@revid)
    if @review.emailcomments
      @user = User.find(@review.provider_id)
      if @user
        @message = "Hi " + @user.login.capitalize + ",\r\n\r\nYour review has received a comment.  Click on the following link to read it: http://www.73s.org/reviews/show/" + @revid + ".  \r\n\r73s,\r\n73s.org Admin"
        Notifier::deliver_email_user(@user.email, 'admin@73s.org', '73s.org Review Comment Received', @message)
      end
    end    
    
    #@comment_pages, @comments = paginate :comments, :order => 'timestamp ASC', :per_page => 5, :conditions => [ "controllername = ? and controllerid = ?", 'reviews', @comment.controllerid]
    @comments = Comment.paginate(:conditions => [ "controllername = ? and controllerid = ?", 'reviews', @comment.controllerid],
    :order => 'timestamp DESC', 
    :per_page => 5,
    :page => params[:page])

    render :partial => 'comments', :object => @comments

  else
    redirect_to :action => 'show', :id =>  @comment.controllerid
  end
end

def rate
  #@rating = Rating.find(params[:id])
  #Rating.delete_all(["rateable_type = 'Beers' AND rateable_id = ? AND user_id = ?", @asset.id, current_user.id])
  #@beer.add_rating Rating.new(:rating => params[:rating], :user_id => current_user.id)

  @killrating = Rating.find(:first, :conditions => [ "profile_id = ? and controllername = ? and controllerid = ?", @p.id, "reviews", params[:id]])
  if @killrating != nil
    @killrating.destroy
  end

  @newrating = Rating.new
  @newrating.profile_id = @p.id
  @newrating.controllername = "reviews"
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
    
    @getrating = Rating.find(:all, :conditions => [ "controllername = ? and controllerid = ?", "reviews", @reviewid])
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


def tags
  #Tag Cloud
  #@tags = Tag.tags(:limit => 100, :order => "name desc")
  #@tags = Tag.tags(:limit => 100, :order => "name asc")
  @tags = Review.tag_counts
  
end

def tag
  #Specific tag from tag cloud
  @tagname = params[:id]
  #@reviews = Review.find_tagged_with(@tagname)     

  #@review_pages, @reviews = paginate :reviews,
  #{:conditions => ["tags.name=?", @tagname],
  #:joins => "INNER JOIN taggings ON reviews.id = taggings.taggable_id INNER JOIN tags ON taggings.tag_id = tags.id",
  #:order=>"timestamp DESC",
  #:select=>"reviews.*"  }
  
  @reviews = Review.paginate(:conditions => ["tags.name=?", @tagname],
  :joins => "INNER JOIN taggings ON reviews.id = taggings.taggable_id INNER JOIN tags ON taggings.tag_id = tags.id",
  :order=>"timestamp DESC",
  :select=>"reviews.*",
  :per_page => 5,
  :page => params[:page])
  
  
  
end

def rss
  headers["Content-Type"] = "application/xml" 
  yestime = Time.now.yesterday
  
  if params[:id].nil?
    @reviews = Review.find(:all, :conditions => [ "timestamp > ? ", Time.now.year.to_s + '/' + Time.now.month.to_s + '/' + Time.now.day.to_s + ' 00:00:00'])
    if @reviews.size < 10
      @reviews = Review.find(:all, :limit => 10, :order => 'timestamp DESC')
    end
  else
    @reviews = Review.find(:all, :conditions => [ "timestamp > ? && candidate_id = ?", Time.now.year.to_s + '/' + Time.now.month.to_s + '/' + Time.now.day.to_s + ' 00:00:00', params[:id]])
    if @reviews.size < 10
      @reviews = Review.find(:all, :conditions => [ "candidate_id = ?", params[:id]], :limit => 10, :order => 'timestamp DESC')
    end
  end
  
  render :layout => false
  
end

def thumbup
  @review = Review.find(params[:id])
  @thumbup = @review.thumbsup + 1
  @thumbdown = @review.thumbsdown
  @review.thumbsup = @thumbup
  @review.save
  #@review.update_attributes(:thumbsup => @thumbup)
  session[":thumb" + params[:id].to_s] = true

  render :action => 'thumbs', :layout => false
end

def thumbdown
  @review = Review.find(params[:id])
  @thumbdown = @review.thumbsdown + 1
  @thumbup = @review.thumbsup
  @review.thumbsdown = @thumbdown
  @review.save
  session[":thumb" + params[:id].to_s] = true

  render :action => 'thumbs', :layout => false  
end

def search
  
  if params[:page] == nil
    @searchterm = params[:search][:searchTextBox]
  end 
  
  if @searchterm != nil
    session[:searchterm] = @searchterm
  end
  
  #@review_pages, @reviews = paginate :reviews, :order => 'timestamp DESC', :per_page => 5, :conditions => [ "title LIKE ? || body LIKE ?", "%" + session[:searchterm] + "%", "%" + session[:searchterm] + "%" ]
  @reviews = Review.paginate(:conditions => [ "title LIKE ? || body LIKE ?", "%" + session[:searchterm] + "%", "%" + session[:searchterm] + "%" ],
  :order => 'timestamp DESC', 
  :per_page => 5,
  :page => params[:page])
  
  
  #@revs = @review_pages.item_count
  
  
end


protected

def allow_to
  super :owner, :all => true
  super :user, :all => true
  super :all, :only => [:index, :show]
end

end
