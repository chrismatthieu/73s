# require 'net/telnet'
require 'rubygems'
require 'open-uri'
require 'cgi'
require 'json'


class StatusesController < ApplicationController

  skip_filter :login_required, :only => [:callsign, :index, :hamfeed, :poll]
  before_filter :setup, :except => [:callsign, :hamfeed, :poll]
  
  include Net
  
  # GET /statuses
  # GET /statuses.xml
  def index
    #@statuses = Status.find(:all, :order => "created_at desc")
    @statuses = Status.paginate(:all, 
    :order => "created_at desc", 
    :conditions => ['privatemsg != ?', true],
    :per_page => 10,
    :page => params[:page])

    @replycall = params[:replycall]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @statuses }
      format.rss {render :layout=>false}
      format.iphone
    end
  end


  def directs
    @statuses = Status.paginate(:all, 
    :order => "created_at desc", 
    :conditions => ['privatemsg = ? and (profile_id = ? or message like ?)', true, @p.id, '%' + @p.user.login + '%'],
    :per_page => 10,
    :page => params[:page])

    respond_to do |format|
      format.html {render :action => "index"}
      format.xml  { render :xml => @statuses }
      format.iphone
    end
  end

  def replies
    @statuses = Status.paginate(:all, 
    :order => "created_at desc", 
    :conditions => ['profile_id != ? and message like ?', @p.id, '%' + @p.user.login + '%'],
    :per_page => 10,
    :page => params[:page])

    respond_to do |format|
      format.html {render :action => "index"}
      format.xml  { render :xml => @statuses }
      format.iphone
    end
  end


  # GET /statuses/1
  # GET /statuses/1.xml
  def show
    @status = Status.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @status }
    end
  end

  # GET /statuses/new
  # GET /statuses/new.xml
  def new
    @status = Status.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @status }
      format.iphone
    end
  end

  # GET /statuses/1/edit
  def edit
    @status = Status.find(params[:id])
  end

  # POST /statuses
  # POST /statuses.xml
  def create
    #Post message to 73s
    @status = Status.new(params[:status])
    @status.profile_id = @p.id

    txtarray = params[:status][:message].split(" ")
    if !txtarray.blank? and txtarray[0].downcase == "d" #Is message a direct message for APRS?
      @status.privatemsg = true
    end

    respond_to do |format|
      if @status.save
        flash[:notice] = 'Status was successfully created.'

        #Post direct message to APRS
        if txtarray[0].downcase == "d" #Is message a direct message for APRS?
          
          txtcall = txtarray[1].gsub("@", "")
          
          re1="((?:[a-z][a-z]*[0-9]+[a-z0-9]*))"	# Alphanum 1
          re=(re1)
          m=Regexp.new(re,Regexp::IGNORECASE);
          if m.match(txtcall) #Is target id a callsign (ex: "d kb7pwx")
              
              # #OPENAPRS TelNet Solution
              # wrouter = Net::Telnet::new("Host" => "dcc.openaprs.net",
              #                                 "Timeout" => 10, "Port" => "2620",
              #                                 "Waittime" => 2.0,
              #                                 "Prompt" => /.*/)
              # 
              # data = params[:status][:message].split(txtcall)
              # txtmessage = data[1] + ' de ' + @p.user.login
              # 
              # commands = ['.LN n7ice@73s.org openaprs', '.CM TO:' + txtcall + '|MS:' +  txtmessage]
              # 
              # commands.each do |command|
              #   wrouter.cmd(command){ |c| print c }
              # end


              # FINDU Solution
              # http://www.findu.com/cgi-bin/sendmsg.cgi?fromcall=N7ICE&tocall=n7ice&msg=That+URL+totally+works!++Thank+you!
              data = params[:status][:message].split(txtcall)
              # aprsmsg = '@' + @p.user.login.upcase + ': ' + data[1].strip() + ' via 73s.org'
              aprsmsg = @p.user.login.upcase + '-' + data[1].strip() + ' via 73s.org'
              # @url = 'http://www.findu.com/cgi-bin/sendmsg.cgi?fromcall=' + @p.user.login.upcase + '&tocall=' + txtcall.upcase + '&msg=' + CGI.escape(aprsmsg)
              @url = 'http://www.findu.com/cgi-bin/sendmsg.cgi?fromcall=73S&tocall=' + txtcall.upcase + '&msg=' + CGI.escape(aprsmsg)
              @results = open(@url)
              
              flash[:notice] = 'Direct APRS message was sent successfully.'
          
          end

        else

          #Post message to Twitter
          @twitusername = @p.twitter_name
          if @twitusername == nil || !@p.twitter_pass.blank?
            @twituser = ""
          else
            @twituser = " (@#{@twitusername})"
          end

          @tweet = params[:status][:message] + " - http://73s.org/" + @p.user.login 
          twitter(@tweet)
  
        end  
        

        format.html { redirect_to('/statuses') }
        format.xml  { render :xml => @status, :status => :created, :location => @status }
        format.iphone { redirect_to('/' + @p.user.login + '/mystatus') }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @status.errors, :status => :unprocessable_entity }
        format.iphone { render :action => "new" }
      end
    end
  end

  # PUT /statuses/1
  # PUT /statuses/1.xml
  def update
    @status = Status.find(params[:id])

    respond_to do |format|
      if @status.update_attributes(params[:status])
        flash[:notice] = 'Status was successfully updated.'
        format.html { redirect_to('/statuses') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @status.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /statuses/1
  # DELETE /statuses/1.xml
  def destroy
    @status = Status.find(params[:id])
    if @status.profile_id == @p.id
      @status.destroy
    end
    
    respond_to do |format|
      format.html { redirect_to(statuses_url) }
      format.xml  { head :ok }
    end
  end
  
  def callsign
    @callsign = params[:callsign]
  
    #@user = User.find_by_login(@callsign) 
    # @userx = User.find(:first, :conditions => ['login = ?', @callsign])
    # @userx = User.find(:first, :conditions => ['login ILIKE ?', @callsign])           
    if request.url.index('localhost')
      @userx = User.find(:first, :conditions => ['login LIKE ?', @callsign])         
    else
      @userx = User.find(:first, :conditions => ['login ILIKE ?', @callsign])         
    end
    
  
    if @userx

      #params[:profile_id] = @userx.profile.id

      #setup
      
      #index
      
      #@statuses = Status.find(:all, :conditions => ["profile_id = ?", @userx.profile.id], :order => "created_at desc")      
      if @p.id == @userx.profile.id
        @statuses = Status.paginate(:all, 
        :conditions => ["profile_id = ?", @userx.profile.id],
        :order => "created_at desc", 
        :per_page => 10,
        :page => params[:page])
      else
        @statuses = Status.paginate(:all, 
        :conditions => ["profile_id = ? and privatemsg != ?", @userx.profile.id, true],
        :order => "created_at desc", 
        :per_page => 10,
        :page => params[:page])
      end
      
      render :action => 'index'
    
    else
      redirect_to(:controller => 'home', :action => 'callsign', :id => @callsign)
    end
  end
  
  def hamfeed
    render :action => 'index'
  end

  def friends
    #@statuses = Status.find(:all, :order => "created_at desc")
    
    if @p.has_network?

      # @statuses = Status.paginate.find_by_sql("select distinct statuses.profile_id, statuses.message, statuses.created_at from statuses, friends where statuses.profile_id = friends.inviter_id and statuses.profile_id = #{@p.id} order by statuses.created_at DESC")
      # @statuses = Status.paginate_by_sql("select distinct statuses.profile_id, statuses.message, statuses.created_at from statuses, friends where statuses.profile_id = friends.inviter_id and statuses.profile_id = #{@p.id} order by statuses.created_at DESC", :per_page => 10, :page => params[:page])
      @statuses = Status.paginate_by_sql("select distinct statuses.profile_id, statuses.message, statuses.created_at from statuses, friends where (statuses.profile_id = friends.invited_id and friends.inviter_id = #{@p.id} and statuses.privatemsg = false) or (statuses.profile_id = #{@p.id}) order by statuses.created_at DESC", :per_page => 10, :page => params[:page])
            
    else
      
      @statuses = Status.paginate(:all, 
      :conditions => ['privatemsg != ?', true],
      :order => "created_at desc", 
      :per_page => 10,
      :page => params[:page])
      
    end

    # :conditions => ["invited_id = ? or inviter_id = ?", id, id]).blank?
    # find_by_sql ["select * from artists where ucase(left(artist_name, 1)) = ?", letter]
    
    # if @p.received_messages.empty? && @p.has_network?
    #   flash[:notice] = 'You have no mail in your inbox.  Try sending a message to someone.'
    #   @to_list = (@p.followers + @p.friends + @p.followings)
    #   redirect_to new_profile_message_path(@p) and return
    # end
    

    respond_to do |format|
      format.html { render :action => 'index' }
      format.xml  { render :xml => @statuses }
      format.iphone { render :action => 'index' }
    end
  end

  def poll
    
    # APRS.FI APIKEY = 27286.QJTmrxJGMvlNh
    # http://api.aprs.fi/api/get?what=msg&dst=N7ICE&apikey=27286.QJTmrxJGMvlNh&format=json
    # {"command":"get","result":"ok","found":1,"what":"msg","entries":[{"messageid":"19963994","time":"1307195053","srccall":"73S","dst":"N7ICE","message":"N7ICE-test from 73s via 73s.org"}]}
    
        @aprsupdate = Aprsupdate.find(:first)
        #OPENAPRS - DEFAULT TIMEZONE: America/Los_Angeles
        #TimeStamp is in Unix timestamp epoch format Time.now.to_i


        #@published = (@aprsupdate.published + 7.hours).to_i  #UTC = -5 hours at server location 
        #@published = @aprsupdate.published.to_i  #UTC  
        @published = (@aprsupdate.published - 5.minutes).to_i #do get around a slow clock on open aprs

        @aprs = open("http://api.aprs.fi/api/get?what=msg&dst=73S&apikey=27286.QJTmrxJGMvlNh&format=json") {|f| f.read }
        result = JSON.parse(@aprs)
        
        result["entries"].each do |msg| 
          if msg["time"].to_i > @published

            @source = msg['srccall']
            @rawmsg = msg['message'] 
            @message = @rawmsg + ' via APRS'
          
            if !@rawmsg.blank? 

              @txtarray = @rawmsg.split(" ")

              if @txtarray[0].downcase == "time"

                 @time = Time.now.gmtime

                 aprsmsg = 'Current Time is ' + @time.to_s + ' UTC via 73s.org'
                 @url = 'http://www.findu.com/cgi-bin/sendmsg.cgi?fromcall=73S&tocall=' + @source.upcase + '&msg=' + CGI.escape(aprsmsg)
                 @results = open(@url).read


              elsif @txtarray[0].downcase == "echo"

                   @data = @rawmsg.split('echo')
                   aprsmsg = @data[1].strip() + ' via 73s.org'
                   @url = 'http://www.findu.com/cgi-bin/sendmsg.cgi?fromcall=73S&tocall=' + @source.upcase + '&msg=' + CGI.escape(aprsmsg)
                   @results = open(@url).read

               else 

                 #update 73s status
                 #NEED TO ACCOUNT FOR SUFFIX HANDLING
                 @rootsource = @source.split("-")
                 @source = @rootsource[0]

                 if request.url.index('localhost')
                   @callsign = User.find(:first, :conditions => ['login LIKE ?', @source])
                  else
                   @callsign = User.find(:first, :conditions => ['login ILIKE ?', @source])
                 end
                 
                 @status = Status.new

                 if @callsign
                    @status.profile_id = @callsign.profile.id
                    @status.message = @message
                    @status.save
                 end 


                 #retweeting 
                 if @callsign and @callsign.access_token
                   @tweet = @message + " - http://73s.org/" + @callsign.login 

                   if @tweet.length > 133
                     @tweet = @tweet[0..130] + "..."
                   end

                  @client = TwitterOAuth::Client.new(
                       :consumer_key => '5Yr0l7nhb8JbwCpnsxyCA',
                       :consumer_secret => 'sxHqc42O0eNU8C2KlVmDB67jsXRftOwLMYrgh6PGM4',
                       :token => @callsign.access_token,
                       :secret => @callsign.access_secret
                   )
                   @client.update(@tweet)    


                 end
                 
              end

            end

           end
         end


        @aprsupdate.published = Time.now()
        @aprsupdate.save
        
        render :layout=>false
    
  end

  
  private

  def allow_to 
    #super :all, :only => [:index, :show, :callsign]
    super :all, :all=>true
  end
  
  def setup
  end
  
end
