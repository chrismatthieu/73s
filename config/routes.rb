ActionController::Routing::Routes.draw do |map|
  map.resources :articles
  map.resources :lists
  map.resources :products
  map.resources :categories
  map.resources :companies
  map.resources :groupers
  map.resources :groups
  map.resources :adverts
  map.resources :statuses
  map.resources :hambriefs
  map.resources :gears
  map.resources :repeaters
  map.resources :clubs
  map.resources :events
  map.resources :contacts
  map.resources :reviews
  map.resources :directory
  #map.resources :qsos
  map.resources :home
  map.resources :timelines
  map.resources :comments

  
  map.namespace :admin do |a|
    a.resources :users, :collection => {:search => :post}
  end

  #map.connect '/adverts/redir/:id', :controller => 'adverts', :action => 'redir'
  map.with_options(:controller => 'adverts') do |adverts|
    adverts.redir   "/adverts/redir",   :action => 'redir'
  end


  # Simple-Forums plugin
  map.resources :forums do |forum|
    forum.resources :topics do |topic|
      topic.resources :posts
    end
  end

  ## Lovd by Less Forum Routes
  # map.resources :forums, :collection => {:update_positions => :post} do |forum|
  #   forum.resources :topics, :controller => :forum_topics do |topic|
  #     topic.resources :posts, :controller => :forum_posts
  #   end
  # end


  map.connect 'blogs/all', :controller => 'blogs', :action => 'all'
  map.connect 'blogs.:format', :controller => 'blogs', :action => 'rss'  

  map.connect 'reviews/rss', :controller => 'reviews', :action => 'rss'  

  map.resources :profiles, 
  :member=>{:delete_icon=>:post}, :collection=>{:search=>:get}, 
  :has_many=>[:friends, :blogs, :photos, :comments, :feed_items, :messages]

  map.resources :messages, :collection => {:sent => :get}
  map.resources :blogs do |blog|
    blog.resources :comments
  end

  map.with_options(:controller => 'accounts') do |accounts|
    accounts.login   "/login",   :action => 'login'
    accounts.logout  "/logout",  :action => 'logout'
    accounts.signup  "/signup",  :action => 'signup'
    # accounts.signup  "/activate",  :action => 'activate'
  end

  map.with_options(:controller => 'clubs') do |clubs|
    clubs.state_select   "/state_select",   :action => 'state_select'
  end
  map.with_options(:controller => 'events') do |events|
    events.state_select   "/state_select",   :action => 'state_select'
  end

  map.with_options(:controller => 'contacts') do |contacts|
    contacts.state_select   "/state_select",   :action => 'state_select'
    contacts.map   "/map",   :action => 'map'
    contacts.upload   "/upload",   :action => 'upload'
  end
  map.connect ':callsign/graph', :controller => 'contacts', :action => 'graph'
  map.connect ':callsign/relationBrowser.:format', :controller => 'contacts',  :action => 'relationBrowser'
  
  map.with_options(:controller => 'reviews') do |reviews|
    reviews.best    "/best",  :controller => 'reviews', :action => 'best'
    reviews.popular "/popular",  :controller => 'reviews', :action => 'popular'
    reviews.worst   "/tags",  :controller => 'reviews', :action => 'tags'
    reviews.worst   "/worst",  :controller => 'reviews', :action => 'worst'
  end

  map.with_options(:controller => 'directory') do |directory|
    directory.main    "/index",  :controller => 'directory', :action => 'index'
    directory.newest    "/newest",  :controller => 'directory', :action => 'newest'
    directory.twitterview "/twitterview",  :controller => 'directory', :action => 'twitterview'
    directory.skype   "/skype",  :controller => 'directory', :action => 'skype'
    directory.aprs   "/aprs",  :controller => 'directory', :action => 'aprs'
  end

  map.connect 'qsos/:id/:contact/:year/:month', :controller => 'qsos', :action => 'index'
  map.connect 'qsos/:id/:contact/:year', :controller => 'qsos', :action => 'index'
  map.connect 'qsos/:id/:contact', :controller => 'qsos', :action => 'index'
  map.connect 'qsos/:id', :controller => 'qsos', :action => 'index'
  
  
  map.with_options(:controller => 'home') do |home|
    home.home '/', :action => 'index'
    home.latest_comments '/latest_comments.rss', :action => 'latest_comments', :format=>'rss'
    home.newest_members '/newest_members.rss', :action => 'newest_members', :format=>'rss'
    home.tos '/tos', :action => 'terms'
    home.aboutus '/aboutus', :action => 'aboutus'
    home.sitesearch '/sitesearch', :action => 'sitesearch'
    home.about '/about', :action => 'about'
    home.about '/widget', :action => 'widget'
    home.unsubscribe '/unsubscribe', :action => 'unsubscribe'
    home.taf '/taf', :action => 'taf'
    home.tafmail '/tafmail', :action => 'tafmail'
  end
  map.connect '/dx', :controller => 'home', :action => 'dx'
  map.connect '/dxlive', :controller => 'home', :action => 'dxlive'
  map.connect '/apis', :controller => 'home', :action => 'apis'
  map.connect '/live', :controller => 'home', :action => 'live'
  map.connect '/sitesearch', :controller => 'home', :action => 'sitesearch'
  map.connect '/callsignlookup', :controller => 'home', :action => 'callsignlookup'
  map.connect '/register', :controller => 'home', :action => 'register'

  map.connect '/hamfeed', :controller => 'statuses', :action => 'hamfeed'

  map.connect '/connect', :controller => 'home', :action => 'connect'
  map.connect '/callback', :controller => 'home', :action => 'callback'



  map.callsign 'callsign/:callsign', :controller => 'home', :action => 'callsign'

  map.connect 'search', :controller => 'repeaters', :action => 'search'

  map.confirm '/confirm', :controller => 'contacts', :action => 'confirm'
  map.connect 'confirm/:confirmation_code', :controller => 'contacts', :action => 'confirm'

  map.connect 'callsign/user/:id', :controller => 'home', :action => 'callsign'
  map.connect ':callsign', :controller => 'profiles', :action => 'callsign'
  map.connect ':id.:format', :controller => 'home', :action => 'callsign'

  map.connect ':callsign/blogs.:format', :controller => 'blogs', :action => 'callsign'
  map.connect ':callsign/blogs/:id', :controller => 'blogs', :action => 'callsign'
  map.connect ':callsign/blogs/:id.:format', :controller => 'blogs', :action => 'callsign'
  map.connect ':callsign/blog/:id', :controller => 'blogs', :action => 'callsignshow'
  map.connect ':callsign/photos/:id', :controller => 'photos', :action => 'callsign'
  map.connect ':callsign/aprs', :controller => 'aprs', :action => 'callsign'
  map.connect ':callsign/timeline', :controller => 'timeline', :action => 'callsign'
  map.connect ':callsign/timeline.:format', :controller => 'timeline', :action => 'callsign'
  map.connect ':callsign/mystatus', :controller => 'statuses', :action => 'callsign'
  map.connect ':callsign/status', :controller => 'statuses', :action => 'friends'
  map.connect ':callsign/directs', :controller => 'statuses', :action => 'directs'
  map.connect ':callsign/replies', :controller => 'statuses', :action => 'replies'
  map.connect ':callsign/gear', :controller => 'lists', :action => 'callsign', :mode => 'gear'
  map.connect ':callsign/widget', :controller => 'lists', :action => 'callsign', :mode => 'widget'

  map.connect '/company/:company_id/product/new.:format', :controller => 'products', :action => 'new'
  map.connect '/company/:company_id/product/:id/edit.:format', :controller => 'products', :action => 'edit'
  map.connect '/company/:company_id/product/:id.:format', :controller => 'products', :action => 'index'
  map.connect '/company/:company_id/products', :controller => 'products', :action => 'index'

  map.connect '/products/:id/edit', :controller => 'products', :action => 'update'
  map.connect '/companies/:id/edit', :controller => 'companies', :action => 'update'
  map.connect '/twitter/deauthorize/:id', :controller => 'profiles', :action => 'deauth'



  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'


end
