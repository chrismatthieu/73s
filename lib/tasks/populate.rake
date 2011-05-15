require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'cgi'

namespace :utils do

  # Email Hams daily activity
  # rake utils:email_summary  
  
  task(:email_summary => :environment) do
    @url = 'curl -i -X GET http://73s.org/feed_items/summary'
    @feed = `#{@url}`
  end

  # rake utils:aprs_feeds  
  task(:aprs_feeds => :environment) do
    @aprsupdate = Aprsupdate.find(:first)
    #OPENAPRS - DEFAULT TIMEZONE: America/Los_Angeles
    #TimeStamp is in Unix timestamp epoch format Time.now.to_i


    #@published = (@aprsupdate.published + 7.hours).to_i  #UTC = -5 hours at server location 
    #@published = @aprsupdate.published.to_i  #UTC  
    @published = (@aprsupdate.published - 30.seconds).to_i #do get around a slow clock on open aprs

    # #test only
    # @published = @aprsupdate.published.to_i  #UTC = -5 hours at server location 
    # puts @published
    # # @url = 'curl -i -X GET http://www.openaprs.net/ajax/messages/TO/73S&timestamp=' + @published.to_s
    # 
    # #@url = 'curl -i -X GET http://www.openaprs.net/ajax/messages/TO/73S&timezone=America/Chicago&timestamp=' + @published.to_s
    # # @results = `#{@url}`
    # doc = Hpricot.parse(@results)

     doc = Hpricot.parse(open('http://www.openaprs.net/ajax/messages/TO/73S&timestamp=' + @published.to_s))

     (doc/"marker").each do |mkr|
       @source = mkr.attributes['source']
       @rawmsg = mkr.attributes['message'] 
       @message = @rawmsg + ' via APRS'



     # (doc/:marker).each do |item|
     #   @source = (item/:source).inner_html 
     #   # @addressee = (item/:addressee).inner_html 
     #   @message = (item/:message).inner_html 
# puts doc
# puts "source:" + @source     
# puts "msg:" + @message     

# 1.times do
# @rawmsg = 'time'
# @source = 'N7ICE'

      
      if !@rawmsg.blank? 

        @txtarray = @rawmsg.split(" ")
          
         if @txtarray[0].downcase == "time"
           
           @time = Time.now.gmtime
           
           aprsmsg = 'Current Time is ' + @time.to_s + ' UTC via 73s.org'
           @url = 'http://www.findu.com/cgi-bin/sendmsg.cgi?fromcall=73S&tocall=' + @source.upcase + '&msg=' + CGI.escape(aprsmsg)
           @results = open(@url).read

          # @curlurl = 'curl GET ' + @url 
          # @results = `#{@curlurl}`


        elsif @txtarray[0].downcase == "echo"

             @data = @rawmsg.split('echo')
             aprsmsg = @data[1].strip() + ' via 73s.org'
             @url = 'http://www.findu.com/cgi-bin/sendmsg.cgi?fromcall=73S&tocall=' + @source.upcase + '&msg=' + CGI.escape(aprsmsg)
             @results = open(@url).read
             
            # @curlurl = 'curl GET ' + @url 
            # @results = `#{@curlurl}`
          
           
         else 
           
           #update 73s status
           #NEED TO ACCOUNT FOR SUFFIX HANDLING
           @rootsource = @source.split("-")
           @source = @rootsource[0]
           
           @callsign = User.find(:first, :conditions => ["login = ?", @source])
           @status = Status.new
     
           if @callsign
              @status.profile_id = @callsign.profile.id
           else
             @status.profile_id = 1
           end 
     
           @status.message = @message
           @status.save

           #retweeting to @73s
           if @callsign
             if @callsign.profile.twitter_name == nil || @callsign.profile.twitter_pass.blank?
               @creds = '73s:73s73s'
             else
               @creds = @callsign.profile.twitter_name + ':' + @callsign.profile.twitter_pass
             end
           else
             @creds = '73s:73s73s'
           end
         
           @url = 'curl -u ' + @creds  + ' -i -X POST -d status="@' + @source + ' ' + @message + '" http://twitter.com/statuses/update.xml?source=73s'
           @tweet = `#{@url}`
            
        end
        
      end
     
     end
    
    
    @aprsupdate.published = Time.now()
    @aprsupdate.save

  end
  
end