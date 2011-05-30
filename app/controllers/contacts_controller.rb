class ContactsController < ApplicationController

  skip_filter :login_required, :only => [:index, :show, :confirm, :graph]
  before_filter :login_required, :except => :confirm
  
  # before_filter :setup, :except => [:index, :search]
  # before_filter :search_results, :only => [:index, :search]
  # skip_filter :login_required, :only=>[:show, :index, :feed, :search]
  
  
  # GET /contacts
  # GET /contacts.xml
  def index
    
    @callsign = @u.login
    #@contacts = Contact.find(:all)
    #@contacts = current_user.contacts.find(:all, :order => 'contacttime DESC')

#    @totalcontacts = current_user.contacts.size
    @totalcontacts = Contact.count(:conditions => ['profile_id = ?', @u.id])

#    @totalconfirmed = current_user.contacts.count("confirmed")
    @totalconfirmed = Contact.count(:conditions => ['confirmed and (profile_id = ? or callsign = ?)', @u.id, @u.login])
    
#    @contacts = current_user.contacts.paginate(:order => 'contacttime DESC', 
#    :per_page => 10,
#    :page => params[:page])
 
    @contacts = Contact.paginate(:order => 'contacttime DESC', 
        :conditions => ['profile_id = ?', @u.id],
        :per_page => 10,
        :page => params[:page])
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @contacts }
    end
  end

  # GET /contacts/1
  # GET /contacts/1.xml
  def show
    #@contact = Contact.find(params[:id])
    @contact = @p.contacts.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @contact }
    end
  end

  # GET /contacts/new
  # GET /contacts/new.xml
  def new
    #@contact = Contact.new
    @contact = @p.contacts.create
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @contact }
    end
  end

  # GET /contacts/1/edit
  def edit
    @contact = Contact.find(params[:id])
    #@contact = @p.contacts.find(params[:id])
  end

  # POST /contacts
  # POST /contacts.xml
  def create
    #@contact = Contact.new(params[:contact])
    @contact = @p.contacts.create(params[:contact])
    
    #Add logic to handle country codes
    #http://blog.whitet.net/articles/2007/12/17/country-codes-rails-plugin
    if @contact.country.length > 2
      @country = CountryCodes.find_a2_by_name(@contact.country)
      @contact.country = @country
    end

    if @contact.state == nil
      if params[:club][:clubstate] == nil 
        @contact.state = ""
      else
        statelist = params[:club][:clubstate].split(" ")
        @contact.state = statelist[0]
      end
    end 
    
    respond_to do |format|
      if @contact.save
        
        #acts as nested set relationship maintenance
        #@parid = Contact.find(:first, :conditions => ['user_id = ? and callsign = ?', current_user.id, current_user.login])
        #@contact.move_to_child_of @parid
        
        #@contact.tag_with(params[:tags])
        #@contact.tag_with(params[:tag_list])
        
        #update presense
        if @contact.frequency == nil or @contact.frequency == ""
          @stsmsg = 'contacted ' + @contact.callsign.upcase
        else  
          @stsmsg = 'contacted ' + @contact.callsign.upcase + ' on ' + @contact.frequency
        end
        #@user = User.find(@p.id)
        #@user.status = @stsmsg
        #@user.last_active = Time.now
        #@user.save
        
        @twitusername = @p.twitter_name
        if @twitusername == nil || !@p.twitter_pass.blank?
          @twituser = ""
        else
          @twituser = " (@#{@twitusername})"
        end
                
        @tweet = @p.user.login + @twituser + " added contact " + @contact.callsign
        twitter(@tweet)
        
        
        flash[:notice] = 'Contact was successfully created and confirmation request emailed.'
        #format.html { redirect_to(@contact) }
        
        format.html { redirect_to(contacts_url) }
        format.xml  { render :xml => @contact, :status => :created, :location => @contact }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /contacts/1
  # PUT /contacts/1.xml
  def update
    @contact = Contact.find(params[:id])
    #@contact = @p.contacts.find(params[:id])

    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        flash[:notice] = 'Contact was successfully updated and confirmation request emailed.'
        ContactNotifier.deliver_confirmation(@contact)
        #format.html { redirect_to(@contact) }
        #format.html { redirect_to(contact_url) }
        format.html { redirect_back_or_default(:controller => 'contacts', :action => 'index') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.xml
  def destroy
    #@contact = Contact.find(params[:id])
    @contact = @p.contacts.find(params[:id])
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to(contacts_url) }
      format.xml  { head :ok }
    end
  end
  
  def state_select
    render :layout => false
  end
  
  def updatename
    @target  = params[:value]
    @contact = Contact.find(params[:id])
    @contact.name = @target
    @contact.save
    render :text => @target
  end
  
  #def relation_browser
  #  relation_browser :contact
  #end
  
  def tag
    
    @tag = params[:id]
    @contacts = Contact.find_tagged_with(@tag).paginate(:order => 'contacttime DESC', 
    :per_page => 10,
    :page => params[:page])
    
    respond_to do |format|
      format.html # tag.html.erb
      format.xml  { render :xml => @contacts }
    end
    
  end
  
  def confirm
    if params[:confirmation_code]
      @contact = Contact.find_by_confirmation_code(params[:confirmation_code]) 
      if @contact 
        @contact.update_attributes(:confirmed => Time.now)

        @twitusername = @contact.profile.twitter_name
        if @twitusername == nil || !@contact.profile.twitter_pass.blank?
          @twituser = ""
        else
          @twituser = " (@#{@twitusername})"
        end

        @tweet = @contact.callsign + " confirmed QSO with " + @contact.profile.user.login + @twituser
        twitter(@tweet)

        if @p == nil
          # redirect_back_or_default(home_path)
          redirect_to('/' + @contact.profile.user.login )
          flash[:notice] = "Contact confirmed! Sign up to log your QSOs too!" 
        else
          redirect_back_or_default(:controller => '/contacts', :action => 'index')
          flash[:notice] = "Contact confirmed." 
        end
      else
        flash[:error] = "Unable to confirm the QSL.  Did you provide the correct information?" 
      end
    elsif params[:id]
      @contact = Contact.find_by_confirmation_code(params[:id])
      if @contact 
        @contact.update_attributes(:confirmed => Time.now)

        @twitusername = @contact.profile.twitter_name
        if @twitusername == nil || !@contact.profile.twitter_pass.blank?
          @twituser = ""
        else
          @twituser = " (@#{@twitusername})"
        end

        @tweet = @contact.callsign + " confirmed QSO with " + @contact.profile.user.login + @twituser
        twitter(@tweet)

        if @p == nil
          redirect_back_or_default(home_path)
          flash[:notice] = "Contact confirmed! Sign up to log your QSOs too!" 
        else
          redirect_back_or_default(:controller => '/contacts', :action => 'index')
          flash[:notice] = "Contact confirmed." 
        end
      end
    else
      flash.clear
    end
  end
  
  def map
    @contacts = @p.contacts.find(:all)
    #@contacts = Contact.find(:all, :conditions => ['user_id = ? or callsign = ?', current_user.id, current_user.login])
  end
  
  def graph
    @callsign = params[:callsign]
      
    #@user = User.find_by_login(@callsign) 
    # @userx = User.find(:first, :conditions => ['login = ?', @callsign])
    @userx = User.find(:first, :conditions => ['login = UPPER(?)', @callsign.upcase])        
    
      
    if @userx
    
      respond_to do |wants|
        wants.html 
        wants.rss {render  :action => 'index', :layout=>false}
      end
    
    else
      redirect_to(:controller => 'home', :action => 'callsign', :id => @callsign)
    end
    
    #render
  end
  
  def relationBrowser
    @callsign = params[:callsign]
    @contacts = Contact.find(:all)
    @users = User.find(:all)
    render :layout => false
  end
  
  def upload
    render
  end
  
  def adif_import
    @importcount = 0
    content =  params[:dump][:file].read
    contentflat = content.gsub(/[ \t\r\f]/, "") 
    # contentflat = contentflat1.gsub("<EOR>", "<EOR>\r") 
    
    data = contentflat.downcase.split("<eoh>") #ignore everything above the end of header flag

    if data[1].nil?
      record_line = data[0].downcase.split("<eor>") #no header found
    else
      record_line = data[1].downcase.split("<eor>") #header found
    end 

    record_line.each_with_index do |record, i|
        record.chomp!
        # next if record =~ /^\s*#/ #comment in csv
        # next if record =~ /^\s*$/  #blank line in csv
        # if record =~ /^\s*[a-zA-Z\s\D]*\s*$/
        #     puts "header match or record not correct"
        #     next
        #    end   


        contact = Contact.new
        contact.profile_id = @p.id
        contact.created_at = Time.now
        contact.updated_at = Time.now


        record_split = record.split("<") #provides each element without the first < i.e. call:6>iz4ist
        
        record_split.length.times do |i|
          
          
          field_split = record_split[i].split(">") # spit fields into key value pairs
          
          
          if field_split[0][0..6] == "address"
            contact.address = field_split[1]
          end
          if field_split[0][0..2] == "age"
            contact.age = field_split[1]
          end
          if field_split[0][0..8] == "arrl_sect"
            contact.arrl_sect = field_split[1]
          end
          if field_split[0][0..3] == "band"
            contact.band = field_split[1]
          end
          if field_split[0][0..3] == "call"
            contact.callsign = field_split[1]
          end
          if field_split[0][0..3] == "cnty"
            contact.county = field_split[1]
          end
          if field_split[0][0..6] == "comment"
            contact.comment = field_split[1]
          end
          if field_split[0][0..3] == "cont"
            contact.continent = field_split[1]
          end
          if field_split[0][0..9] == "contest_id"
            contact.contestid = field_split[1]
          end
          if field_split[0][0..2] == "cqz"
            contact.cqzone = field_split[1]
          end
          if field_split[0][0..3] == "dxcc"
            contact.dxcc = field_split[1]
          end
          if field_split[0][0..3] == "freq"
            contact.frequency = field_split[1]
          end
          if field_split[0][0..9] == "gridsquare"
            contact.gridsquare = field_split[1]
          end
          if field_split[0][0..3] == "iota"
            contact.iota = field_split[1]
          end
          if field_split[0][0..3] == "ituz"
            contact.ituzone = field_split[1]
          end
          if field_split[0][0..3] == "mode"
            contact.mode = field_split[1]
          end
          if field_split[0][0..3] == "name"
            contact.name = field_split[1]
          end
          if field_split[0][0..4] == "notes"
            contact.notes = field_split[1]
          end
          if field_split[0][0..7] == "operator"
#            contact.operator = field_split[1]
          end
          if field_split[0][0..2] == "pfx"
            contact.wpxprefix = field_split[1]
          end
          if field_split[0][0..8] == "prop_mode"
            contact.propmode = field_split[1]
          end
          if field_split[0][0..5] == "qslmsg"
            contact.qslmessage = field_split[1]
          end
          if field_split[0][0..7] == "qslrdate"
            contact.qslreceivedate = field_split[1]
          end
          if field_split[0][0..7] == "qslsdate"
            contact.qslsentdate = field_split[1]
          end
          if field_split[0][0..7] == "qsl_rcvd"
            contact.qslreceived = field_split[1]
          end
          if field_split[0][0..7] == "qsl_sent"
            contact.qslsent = field_split[1]
          end
          if field_split[0][0..6] == "qsl_via"
            contact.qslvia = field_split[1]
          end
          if field_split[0][0..7] == "qso_date"
            contact.contacttime = field_split[1]
          end
          if field_split[0][0..2] == "qth"
            contact.qth = field_split[1]
          end
          if field_split[0][0..7] == "rst_rcvd"
            contact.rstreceived = field_split[1]
          end
          if field_split[0][0..7] == "rst_sent"
            contact.rstsent = field_split[1]
          end
          if field_split[0][0..5] == "rx_pwr"
            contact.rxpower = field_split[1]
          end
          if field_split[0][0..7] == "sat_mode"
            contact.satellitemode = field_split[1]
          end
          if field_split[0][0..7] == "sat_name"
            contact.satellitename = field_split[1]
          end
          if field_split[0][0..2] == "srx"
            contact.serialreceived = field_split[1]
          end
          if field_split[0][0..4] == "state"
            contact.state = field_split[1]
          end
          if field_split[0][0..2] == "stx"
            contact.serialsent = field_split[1]
          end
          if field_split[0][0..6] == "ten_ten"
            contact.tenten = field_split[1]
          end
          if field_split[0][0..7] == "time_off"
            contact.timeoff = field_split[1]
          end
          if field_split[0][0..6] == "time_on"
            contact.timeone = field_split[1]
          end
          if field_split[0][0..5] == "tx_pwr"
            contact.txpower = field_split[1]
          end
          if field_split[0][0..6] == "ve_prov"
            contact.veprov = field_split[1]
          end
          if field_split[0][0..25] == "app_hamradiodeluxe_country"
            contact.country = field_split[1]
          end
          if field_split[0][0..30] == "app_hamradiodeluxe_my_eqslrdate"
            contact.confirmed = field_split[1]
          end
          
        end

        contact.save
        @importcount = @importcount + 1

    end
    
    #redirect_to(:action => 'index')
    
  end
  
  protected
  
  
  def allow_to
    super :owner, :all => true
    super :user, :all => true
    super :all, :only => [:index, :show, :confirm]
  end  
  
end
