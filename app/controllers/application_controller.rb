require 'open-uri'
require 'twitter_oauth'

class ApplicationController < ActionController::Base
  # test_mode => true forces all requests to be considered as
  # coming from an iPhone.  Otherwise the tank_engine Controller
  # will look at the request to see if an iPhone is on the other side
  # or not.
  
  # acts_as_iphone_controller #:test_mode => true
   
  
  
  helper :all
  include ExceptionNotifiable
  filter_parameter_logging "password"
  
  
  before_filter :allow_to, :check_user, :set_profile, :login_from_cookie, :login_required, :check_permissions, :pagination_defaults #, :check_featured

  after_filter :store_location
  layout 'application'  
  
  
  def check_featured
    # return if Profile.featured_profile[:date] == Date.today
    # Profile.featured_profile[:date] = Date.today
    # Profile.featured_profile[:profile] = Profile.featured

    if Profile.featured_profile[:date] != Date.today
      Profile.featured_profile[:date] = Date.today
      Profile.featured_profile[:profile] = Profile.featured
    end
    
  end
  
  def pagination_defaults
    @page = (params[:page] || 1).to_i
    @page = 1 if @page < 1
    @per_page = (params[:per_page] || (RAILS_ENV=='test' ? 1 : 40)).to_i
  end
  
  def set_profile
    @p = @u.profile if @u && @u.profile
  end
  
  
  
  
  
  
  
  
  helper_method :flickr, :flickr_images
  # API objects that get built once per request
  def flickr(user_name = nil, tags = nil )
    @flickr_object ||= Flickr.new(FLICKR_CACHE, FLICKR_KEY, FLICKR_73s73s)
  end
  
  def flickr_images(user_name = "", tags = "")
    unless RAILS_ENV == "test"# || RAILS_ENV == "development"
      begin
        flickr.photos.search(user_name.blank? ? nil : user_name, tags.blank? ? nil : tags , nil, nil, nil, nil, nil, nil, nil, nil, 20)
      rescue
        nil
      rescue Timeout::Error
        nil
      end
    end
  end
  
  
  protected
  
  def allow_to level = nil, args = {}
    return unless level
    @level ||= []
    @level << [level, args]    
  end
   
  def twitter tweet = nil, args = {}
    
    # # Twitter update - content can be viewed via twitter.com/73s 
    
    # url = URI.parse("http://twitter.com/statuses/update.xml")
    # req = Net::HTTP::Post.new(url.path)
    # if !@p.nil? && !@p.twitter_pass.blank?
    #   req.basic_auth(@p.twitter_name, @p.twitter_pass)
    # else
    #   req.basic_auth('73s', '73s73s')
    # end
    
    status = @tweet
    
    if status.length > 133
      status = status[0..130] + "..."
    end
        
    # req.set_form_data({'status' => status + ' #hamr', 'source' => '73s'})
    # response = Net::HTTP.new(url.host, url.port).start { |http| http.request(req) }
    
    
    ## @url = 'curl -u 73s:73s73s -i -X POST -d status="' + @tweet + ' #hamr" http://twitter.com/statuses/update.xml?source=73s'
    ## @tweet = `#{@url}`

    if session[:access_token]
      
      @client = TwitterOAuth::Client.new(
        :consumer_key => '5Yr0l7nhb8JbwCpnsxyCA',
        :consumer_secret => 'sxHqc42O0eNU8C2KlVmDB67jsXRftOwLMYrgh6PGM4',
        :token => session[:access_token],
        :secret => session[:secret_token]
    )
    @client.update(status)    
    
    end
    
  end
  
  
  
  def check_permissions
    logger.debug "IN check_permissions :: @level => #{@level.inspect}"
    return failed_check_permissions if @p && !@p.is_active
    return true if @u && @u.is_admin
    raise '@level is blank. Did you override the allow_to method in your controller?' if @level.blank?
    @level.each do |l|
      next unless (l[0] == :all) || 
        (l[0] == :non_user && !@u) ||
        (l[0] == :user && @u) ||
        (l[0] == :owner && @p && @p.id==(params[:profile_id] || params[:id]).to_i)
      args = l[1]
      @level = [] and return true if args[:all] == true
      
      if args.has_key? :only
        actions = [args[:only]].flatten
        actions.each{ |a| @level = [] and return true if a.to_s == action_name}
      end
    end
    return failed_check_permissions
  end
  
  def failed_check_permissions
    if RAILS_ENV != 'development'
      flash[:error] = 'It looks like you don\'t have permission to view that page.'
      redirect_back_or_default home_path and return true
    else
      render :text=><<-EOS
      <h1>It looks like you don't have permission to view this page.</h1>
      <div>
        Permissions: #{@level.inspect}<br />
        Controller: #{controller_name}<br />
        Action: #{action_name}<br />
        Params: #{params.inspect}<br />
        Session: #{session.instance_variable_get("@data").inspect}<br/>
      </div>
      EOS
    end
    @level = []
    false
  end

end
