require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'cgi'
require 'twitter_oauth'


class HomeController < ApplicationController
    
   skip_before_filter :login_required, :except=>[:unsubscribe, :widget]
  #in_place_edit_for :index, 'status'

  def contact
    return unless request.post?
    body = []
    params.each_pair { |k,v| body << "#{k}: #{v}"  }
    HomeMailer.deliver_mail(:subject=>"from #{SITE_NAME} contact page", :body=>body.join("\n"))
    flash[:notice] = "Thank you for your message.  A member of our team will respond to you shortly."
    redirect_to contact_url    
  end


 
  def index

    respond_to do |wants|
      wants.html {
        check_featured
        @blogs ||= Blog.find(:all, :order => 'updated_at DESC', :limit => 3)
        @status ||= Status.find(:all, :conditions => ['created_at > ? and privatemsg != ?', Time.now() - 2.days, true], :order => 'created_at DESC', :limit => 3)        
        # @topics = ForumTopic.find(:all, :order => 'created_at DESC', :limit => 3)
        @topics ||= ForumPost.find(:all, :order => 'created_at DESC', :limit => 3)
        @hambrief ||= Hambrief.find(:all, :order => 'updated_at DESC', :limit => 1)
        @qst ||= Review.find(:first, :order => 'timestamp DESC', :limit => 1)
        # @gear ||= Product.find(:all, :order => 'created_at DESC', :limit => 3)
        @gear ||= Gear.find(:all, :order => 'created_at DESC', :limit => 3)
        
        render
        }
      wants.rss {render :partial =>  'profiles/newest_member', :collection => new_members}
      wants.iphone {
        if @p 
          # @list = Array.new
          # @list.push( ListItem.new( "Callsign Lookup", "callsignlookup" ) )
          # # @list.push( ListItem.new( "QSO Logbook", "qsos" ) )
          # @list.push( ListItem.new( "Status Updates", "statuses" ) )
          
          render 
        else
          @user = User.new
          render :action => 'login'
        end
      }
    end
  end 

  def statuslist
    @status = Status.find(:all, :conditions => ['created_at > ?', Time.now() - 2.days], :order => 'created_at DESC', :limit => 3)
    render :partial => 'statuslist'  
  end
  
  def newest_members
    respond_to do |wants|
      wants.html {render :action=>'index'}
      # wants.rss {render :layout=>false}
    end
  end
  def latest_comments
    respond_to do |wants|
      wants.html {render :action=>'index'}
      # wants.rss {render :layout=>false}
    end
  end

  def terms
    render
  end
  
  def statushelp
    render :layout=>false
  end

  def live
    render
  end

  def register
    @user = User.new
    render
  end

  def sitesearch
    if params[:searchtype] == 'Callsign' 
      if params[:q].blank?
        redirect_to "/"
      else  
        redirect_to '/callsign/user?id=' + params[:q].to_s
      end  
  	else
      render
    end
  end
  
  def updatestatus
    @target  = params[:value]
    @user = User.find(params[:id])
    # 
    # @user.status = @target
    # @user.last_active = Time.now
    # @user.save

    @status = Status.new()
    @status.profile_id = params[:id]
    @status.message = @target
    @status.save

    @twitusername = @user.profile.twitter_name
    if @twitusername == nil || !@user.profile.twitter_pass.blank?
      @twituser = ""
    else
      @twituser = " (@#{@twitusername})"
    end
    
    @tweet = @user.login + @twituser + " status - " + @target + " - http://73s.org/" + @user.login 
    twitter(@tweet) rescue ""
    
    @status = Status.find(:all, :conditions => ['profile_id = ?', params[:id]], :order => 'created_at DESC', :limit => 1)
    
    render :text => @target do |page|
      page.insert_html :top, :statustweets, :partial => "statuslist"
    end
    #render :text => @target
  end
  
  def apis
    render
  end
  
  def taf
    @email = params[:email]
    render
  end
  
  def unsubscribe
    @unsub = Profile.find(:first, :conditions => ['id = ?', @p.id])
    @unsub.supresssummary = true
    @unsub.save
  end

  def about
    @totalusers = User.count 
    @newusers = User.count(:conditions => ['created_at > ?', Time.now - 7.days ])
    render
  end

  def callsignlookup
    render
  end

  def widget
    render
  end

  def dx
    #curl -i -X GET http://www.dxanywhere.com/api/cluster_lastten
    @map = GMap.new("map_div")
    
    @icon = GIcon.new(:image => '/images/73s.jpg', :iconSize => GSize.new(48,48), :iconAnchor => GPoint.new(16,24), :infoWindowAnchor => GPoint.new(32,2))
        
    @map.set_map_type_init(GMapType::G_HYBRID_MAP)    
    @map.control_init(:large_map => true,:map_type => true)
    @map.center_zoom_init([33.26,-112.073],3)
    @map.overlay_init(GMarker.new([33.26,-112.073],:title => "N7ICE", :info_window => "73s.org QTH!", :icon => @icon))
    
  end
  
  def dxlive
    #curl -i -X GET http://www.dxanywhere.com/api/cluster_lastten
    render
  end
  
  def dxupdate
    render :partial =>  'dxupdate' 
  end
  
	def dxmap
  	@map = GMap.new("map_div")

    #TEST
    # @map.control_init(:large_map => true,:map_type => true)
    # @map.center_zoom_init([35.12313,-110.567],12)
    # @map.overlay_init GMarker.new([35.12878, -110.578],:title => "Bye!")
    # @map.record_init @map.add_overlay(GMarker.new([35.12878, -110.578],:title => "Bye!"))
    # 
    # GMarker.new([12.4,65.6],:info_window => "I'm a Popup window",:title => "Tooltip")
    # GMarker.new(GLatLng.new([12.3,45.6]))
    # GMarker.new("Rue Clovis Paris France", :title => "geocoded")
    
    #GET NEXT SHOWCASE QSO
    #DXAnywhere API - switched because they could handle our traffic
     # doc = Hpricot.parse(open("http://www.dxanywhere.com/api/cluster_lastten")) 
     # (doc/:spot).each do |item| 
     #   
     #    @dxcallsign = (item/:dxcallsign).inner_html.split("/")[0]
     #    @dxcomment = (item/:comment).inner_html 
     #    @callsign = (item/:callsign).inner_html.split("/")[0]
     #    @callsignlink = '<a href="http://73s.org/' + (item/:callsign).inner_html + '">' + (item/:callsign).inner_html + '</a> on Freq ' + (item/:freq).inner_html + ' at ' + (item/:time).inner_html
     #    @dxcallsignlink = '<a href="http://73s.org/' + (item/:dxcallsign).inner_html + '">' + (item/:dxcallsign).inner_html + '</a> on Freq ' + (item/:freq).inner_html + ' at ' + (item/:time).inner_html
     #  
     #    break
     #  end 


     # http://dxcluster.ham-radio.ch/top_50_ALL.html SCREEN SCRAPING
     doc = Hpricot(open("http://dxcluster.ham-radio.ch/top_50_ALL.html"))
     counter = 0
     
     (doc/"tr/td").each do |td|
         counter = counter + 1
         if td.inner_text != nil 
           if counter == 1
             @dxcallsign = td.inner_text.split(" ")[0].strip() 
           elsif counter == 2
             @freq = td.inner_text 
           elsif counter == 3
             @QSOtime = td.inner_text 
           elsif counter == 4
             @callsign = td.inner_text.split(" ")[0].strip() 
           elsif counter == 5
             @dxcomment = td.inner_text 
           else
             break
           end
         end
      end

       @callsignlink = '<a href="http://73s.org/' + @callsign + '">' + @callsign + '</a> on Freq ' + @freq + ' at ' + @QSOtime
       @dxcallsignlink = '<a href="http://73s.org/' + @dxcallsign + '">' + @dxcallsign + '</a> on Freq ' + @freq + ' at ' + @QSOtime


      
       #QRZ CALLSIGN LOOKUP
       key = Hpricot.parse(open("http://online.qrz.com/bin/xml?username=n7ice;password=dvtdvt;agent=q5.0"))
       (key/:session).each do |item|
         @key = (item/:key).inner_html 
       end
       
       #CONTACTED STATION
       qrz = Hpricot.parse(open("http://online.qrz.com/bin/xml?s=#{@key};callsign=#{@dxcallsign}"))
       (qrz/:callsign).each do |item|
       @imageurl = (item/:image).inner_html   
       @image = '<img src="' + (item/:image).inner_html + '" width="48" height="48">' rescue '' # photourl
       @lat = (item/:lat).inner_html 
       @lon = (item/:lon).inner_html 
       @state = (item/:state).inner_html 
       @country = (item/:country).inner_html 
       end

       if @imageurl.blank?
         @imageurl = "http://73s.org/images/avatar_default_small.png"
       end
       @icon = GIcon.new(:image => @imageurl, :iconSize => GSize.new(48,48), :iconAnchor => GPoint.new(16,24), :infoWindowAnchor => GPoint.new(32,2))
       
       #INITIATING STATION
       qrzinit = Hpricot.parse(open("http://online.qrz.com/bin/xml?s=#{@key};callsign=#{@callsign}"))
       (qrzinit/:callsign).each do |item|
       @initimageurl = (item/:image).inner_html   
       @initimage = '<img src="' + (item/:image).inner_html + '" width="48" height="48">' rescue '' # photourl
       @initlat = (item/:lat).inner_html 
       @initlon = (item/:lon).inner_html 
       @initstate = (item/:state).inner_html 
       @initcountry = (item/:country).inner_html 
       end
       
       if @initimageurl.blank?
         @initimageurl = "http://73s.org/images/avatar_default_small.png"
       end
       @initicon = GIcon.new(:image => @initimageurl, :iconSize => GSize.new(48,48), :iconAnchor => GPoint.new(16,24), :infoWindowAnchor => GPoint.new(32,2))
    

       # #REPLACED QRZ WITH CALLOOK.INFO
       # #CONTACTED STATION
       # callookinfo = Hpricot.parse(open("http://callook.info/index.php?callsign=#{@DXcallsign}&display=xml"))
       # (callookinfo/:callook).each do |item|
       # @imageurl = "http://73s.org/images/avatar_default_small.png"   
       # @image = '<img src="http://73s.org/images/avatar_default_small.png" width="48" height="48">' rescue '' # photourl
       # @lat = (item/:latitude).inner_html 
       # @lon = (item/:longitude).inner_html 
       # @state = (item/:line2).inner_html 
       # @country = "" 
       # end
       # @icon = GIcon.new(:image => @imageurl, :iconSize => GSize.new(48,48), :iconAnchor => GPoint.new(16,24), :infoWindowAnchor => GPoint.new(32,2))
       # 
       # #INITIATING STATION
       # callookinfoinit = Hpricot.parse(open("http://callook.info/index.php?callsign=#{@callsign}&display=xml"))
       # (callookinfoinit/:callook).each do |item|
       # @initimageurl = "http://73s.org/images/avatar_default_small.png"   
       # @initimage = '<img src="http://73s.org/images/avatar_default_small.png" width="48" height="48">' rescue '' # photourl
       # @initlat = (item/:latitude).inner_html 
       # @initlon = (item/:longitude).inner_html 
       # @initstate = (item/:line2).inner_html 
       # @initcountry = ""
       # end
       # @initicon = GIcon.new(:image => @initimageurl, :iconSize => GSize.new(48,48), :iconAnchor => GPoint.new(16,24), :infoWindowAnchor => GPoint.new(32,2))

    
  	
  	  
      #TWITTER VISION STYLE DISPLAY - WORKS GREAT EXCEPT TEXT BUBBLE WON'T AUTO OPEN
      # render :update do |page|
      # if !@lat.blank? and !@lon.blank? 
      #         page << @map.clear_overlays
      #         page << @map.center_zoom_init([@lat,@lon],3)
      #         if @imageurl.nil?
      #             page << @map.add_overlay(GMarker.new([@lat,@lon],:title => @dxcallsign,:info_window => @initimage + @callsignlink + ': ' + @dxcomment))
      #         else   
      #             page << @map.add_overlay(GMarker.new([@lat,@lon],:title => @dxcallsign,:info_window => @initimage + @callsignlink + ': ' + @dxcomment, :icon => @icon ))
      #         end
      #         page.visual_effect :fade, "results", :duration => 0.5
      #       end
      # end
      
      #NEW DISPLAY FORMAT - 2 CONTACTS WITH LINE
      # if !@lat.blank? and !@lon.blank? and !@initlat.blank? and !@initlon.blank? and !@imageurl.blank? and !@initimageurl.blank?
      # if !@lat.blank? and !@lon.blank? and !@initlat.blank? and !@initlon.blank?
  	  if (!@lat.blank? and !@lon.blank?) or (!@initlat.blank? and !@initlon.blank?)
  	    render :update do |page|
      	  page << @map.clear_overlays
      	  page << @map.center_zoom_init([@initlat,@initlon],2)
      	  polyline = GPolyline.new([[@lat,@lon],[@initlat,@initlon]],"#ff0000",2,1.0)
          page << @map.add_overlay(GMarker.new([@initlat,@initlon],:title => @callsign,:info_window => @image + @dxcallsignlink + ': ' + ' (' + @state + ' ' + @country + ') '+ @dxcomment, :icon => @initicon ))
          page << @map.add_overlay(GMarker.new([@lat,@lon],:title => @dxcallsign,:info_window => @initimage + @callsignlink + ': ' + ' (' + @initstate + ' ' + @initcountry + ') ' + @dxcomment, :icon => @icon ))
        	page << @map.overlay_init(polyline)
        	page.visual_effect :fade, "results", :duration => 0.5
        end
      end
      
      #render :text => :false
      
	end  

  def invite
    #send invitation to a QRZ member to join 73s 
    @toprofile = params[:invite][:email]
    HomeMailer.deliver_mail(:subject=>"#{SITE_NAME} Invitation from #{@u.login.upcase}", :body => "#{@u.login.upcase} (http://73s.org/#{@u.login.upcase}) is requesting that you join http://73s.org - the Ham Radio social network.  Here's their message: #{params[:invite][:message]}", :recipients=>@toprofile)
    render :update do |page|
      page.alert "Message sent."
      page << "jq('#message_subject, #message_body').val('');"
      page << "tb_remove()"
    end
  end
  
  def tafmail
    #send invitation to a QRZ member to join 73s 
    @toprofile = params[:invite][:email]
    HomeMailer.deliver_mail(:subject=>"#{SITE_NAME} Invitation from #{@u.login.upcase rescue 'Anonymous'}", :body => "#{@u.login.upcase rescue 'Someone'} (http://73s.org/#{@u.login.upcase rescue ''}) is requesting that you join http://73s.org - the Ham Radio social network.  Here's their message: #{params[:invite][:message]}", :recipients=>@toprofile)
    flash[:notice] = "Invitation sent!  Care to send another one?"
    render :action => 'taf'
  end

  def callsign
    @callsign  = params[:id]

    if @callsign == "users"
      @callsign = params[:id]
    end  

    if @callsign == "Call Sign Search" #http://73s.org/callsign/user?id=
      @callsign = ""
      flash[:notice] = "You must enter a call sign."
      redirect_back_or_default(:controller => 'home', :action => 'index')
    else
      
      @userx = User.find_by_login(@callsign) 
      
      @callelements = Array.new 
      if @userx
        #@callelements[0] = "1"
        #@callelements[1] = ""
        @callelements[2] = @userx.profile.full_name
        #@callelements[3] = ""
        #@callelements[4] = @user.profile.location
        #@callelements[5] = ""
        @callelements[5] = @userx.profile.location
        #@profile = @user.profile.about_me
        #@email = @user.profile.email
        #@website = @user.profile.website
        ##@skype = ""
        

        #redirect_to(:controller => 'profiles', :action => 'show', :id => @userx.id)

        respond_to do |wants|
          wants.html {redirect_to('/' + @callsign )}
          wants.xml {render :layout=>false}
          wants.iphone {redirect_to('/' + @callsign )}
        end
        
      else
        #OLD QRZ SCREEN SCRAPING
        #doc = Hpricot(open("http://www.qrz.com/detail/#{@callsign}"))
        # #returns entire QRZ calldata table
        # @calldata = (doc/"#calldata").to_html
        # counter = 0
        # @callelements[0] = "" # photourl
        # @profile = "" # profile
        # 
        # (doc/"tr/td").each do |td|
        #   if td.attributes['class'] == "q2"
        #     counter = counter + 1
        #     if td.inner_text != nil
        #       @callelements[counter] = td.inner_text 
        #       #1 = header (callsign, class, country)
        #       #2 = name
        #       #3 = street address
        #       #4 = city, state, zip
        #       #5 = country code
        #     end
        #   end
        #  end
        #  if @callelements[5] == "USA"  
        #    @callelements[5] = "US"  
        #  end
         #get email address from qrz.com
         #docemail = Hpricot(open("http://www.qrz.com/p/email.pl?callsign=#{@callsign};from=callsign"))
         

         #COMMENTED OUT DUE TO QRZ BLOCKING OUR ACCESS
         key = Hpricot.parse(open("http://online.qrz.com/bin/xml?username=n7ice;password=dvtdvt;agent=q5.0"))
         (key/:session).each do |item|
           @key = (item/:key).inner_html 
         end
         
         doc = Hpricot.parse(open("http://online.qrz.com/bin/xml?s=#{@key};callsign=#{CGI.escape(@callsign)}"))
         (doc/:callsign).each do |item|
         @callelements[0] = (item/:image).inner_html # photourl
         @callelements[2] = (item/:fname).inner_html + " " + (item/:name).inner_html
         @callelements[3] = (item/:addr1).inner_html + ", " + (item/:addr2).inner_html
         @callelements[4] = (item/:city).inner_html + ", " + (item/:state).inner_html + " " + (item/:zip).inner_html
         @callelements[5] = (item/:country).inner_html 
         @email = (item/:email).inner_html 
         @lat = (item/:lat).inner_html 
         @lon = (item/:lon).inner_html 



         # #ADDED CALLOOK.INFO TO REPLACE QRZ
         # doc = Hpricot.parse(open("http://callook.info/index.php?callsign=#{@callsign}&display=xml"))
         # (doc/:callook).each do |item|
         # @callelements[0] = "" # photourl
         # @callelements[2] = (item/:name).inner_html 
         # 
         # @callelements[3] = (item/:line1).inner_html
         # @callelements[4] = (item/:line2).inner_html
         # @callelements[5] = "US"
         # @email = ""
         # @lat = (item/:latitude).inner_html 
         # @lon = (item/:longitude).inner_html 
         
         end
         
         if @callelements[5] == "USA"  
           @callelements[5] = "US"  
         end


         respond_to do |wants|
           wants.html 
           wants.xml {render :layout=>false}
           wants.iphone 
         end         
         
         
      end #user not found

    end  #callsign valid
  end

  def connect
    @client = TwitterOAuth::Client.new(
        :consumer_key => '5Yr0l7nhb8JbwCpnsxyCA',
        :consumer_secret => 'sxHqc42O0eNU8C2KlVmDB67jsXRftOwLMYrgh6PGM4'
    )
    request_token = @client.request_token(
      :oauth_callback => 'http://73s.org/callback'
    )
    session[:request_token] = request_token.token
    session[:request_token_secret] = request_token.secret
    # redirect request_token.authorize_url        
    redirect_to request_token.authorize_url.gsub('authorize', 'authenticate')
  end
  
  def callback
    @client = TwitterOAuth::Client.new(
        :consumer_key => '5Yr0l7nhb8JbwCpnsxyCA',
        :consumer_secret => 'sxHqc42O0eNU8C2KlVmDB67jsXRftOwLMYrgh6PGM4'
    )
    @access_token = @client.authorize(
      session[:request_token],
      session[:request_token_secret],
      :oauth_verifier => params[:oauth_verifier]
    )
    if @client.authorized?
      # Storing the access tokens so we don't have to go back to Twitter again
      # in this session.  In a larger app you would probably persist these details somewhere.
      session[:access_token] = @access_token.token
      session[:secret_token] = @access_token.secret
      # session[:user] = true      
    
      @user = @u
      @user.access_token = @access_token.token
      @user.access_secret = @access_token.secret
      @user.save

    end
    
  end


  private

  def allow_to 
    super :all, :all=>true
  end

end



class HomeMailer < ActionMailer::Base
  def mail(options)
    self.generic_mailer(options)
  end
end


class ListItem
  def initialize( cap, url )
    @cap = cap
    @url = url
  end

  def caption
    @cap
  end

  def url
    @url
  end
end
