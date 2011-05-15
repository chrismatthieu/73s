require 'rubygems'
require 'hpricot'
require 'open-uri'

class AccountsController < ApplicationController
  skip_before_filter :login_required, :except => :logout
  skip_after_filter :store_location
  layout 'plain'




  def login
    session[:user] = nil
    respond_to do |wants|
      wants.html {

    if @u and @p.user.is_admin 
      @u = User.find_by_login(params[:login])
      flash[:notice] = "Hello #{@u.f rescue ''}"
      # cookies[:auth_token] = {:expires => Time.now-1.day, :value => "" }
      session[:user] = @u
      session[:admin] = true
      redirect_to :controller => :home, :action => :index 
    else  
    
      # self.user = User.authenticate(params[:login], params[:password])
      redirect_back_or_default(home_path) and return if @u
      @user = User.new
      return unless request.post?
    
    
      #plays double duty login/forgot (due to the ajax nature of the login/forgot form)
      if params[:user][:email] && params[:user][:email].size > 0
        u = Profile.find_by_email(params[:user][:email]).user rescue nil
        flash.now[:error] = "Could not find that email address. Try again." and return if u.nil?

        @pass = u.forgot_password #must be @ variable for function tests
        AccountMailer.deliver_forgot_password(u.profile.email, u.f, u.login, @pass)
        flash.now[:notice] = "A new password has been mailed to you."
      else
        params[:login] ||= params[:user][:login] if params[:user]
        params[:password] ||= params[:user][:password] if params[:user]
        self.user = User.authenticate(params[:login], params[:password])
        if @u
          
          session[:access_token] = @u.access_token
          session[:secret_token] = @u.access_secret
          # session[:user] = true      
          
          
          remember_me if params[:remember_me] == "1"
          flash[:notice] = "Hello #{@u.f}"

          
          # # This is currently redirecting to the advert banner
          # redirect_back_or_default profile_url(@u.profile)
          redirect_to :controller => :home, :action => :index        
          
        else
          flash.now[:error] = "Uh-oh, login didn't work. Do you have caps locks on? Try it again."
          redirect_to "/login"
        end
      end
    end
    }
    wants.iphone {
      # redirect_back_or_default(home_path) and return if @u
      @user = User.new
      # return unless request.post?
        #       
        # render :controller => 'home', :action => 'login'
        
        params[:login] ||= params[:user][:login] if params[:user]
        params[:password] ||= params[:user][:password] if params[:user]
        self.user = User.authenticate(params[:login], params[:password])
        if @u
          
          remember_me if params[:user][:remember_me] == "1"
          flash[:notice] = "Hello #{@u.f}"

          
          # # This is currently redirecting to the advert banner
          # redirect_back_or_default profile_url(@u.profile)
          redirect_to :controller => :home, :action => :index        
          
        else
          # flash.now[:error] = "Uh-oh, login didn't work. Do you have caps locks on? Try it again."
          render "/login"
        end
        
    }
  end
  end
  
  
  
  

  def logout
    cookies[:auth_token] = {:expires => Time.now-1.day, :value => "" }
    session[:user] = nil
    session[:return_to] = nil
    session[:admin] = false
    flash[:notice] = "You have been logged out."
    redirect_to '/'
  end
  
  
  



  def signup
    
    redirect_back_or_default(home_path) and return if @u
    @user = User.new
    return unless request.post?
    
#COMMENTED OUT TO DEAL WITH QRZ.COM BLOCKING OUR REQUESTS
    @callelements = Array.new 
    
    #QRZ API = http://online.qrz.com/specifications.html
    #Gets Key = http://online.qrz.com/bin/xml?username=n7ice;password=dvtdvt;agent=q5.0
    #QRZ API Key = 102443u0783e90e50e018b1edd829150410786d
    #Callsign = http://online.qrz.com/bin/xml?s=102443u0783e90e50e018b1edd829150410786d;callsign=n7ice
    
    key = Hpricot.parse(open("http://online.qrz.com/bin/xml?username=n7ice;password=dvtdvt;agent=q5.0"))
    (key/:session).each do |item|
      @key = (item/:key).inner_html 
    end
    
    doc = Hpricot.parse(open("http://online.qrz.com/bin/xml?s=#{@key};callsign=#{params[:user][:login]}"))
    
     (doc/:callsign).each do |item|
     @callelements[0] = "" # photourl
     @callelements[2] = (item/:fname).inner_html + " " + (item/:name).inner_html
     @callelements[3] = (item/:addr1).inner_html + ", " + (item/:addr2).inner_html
     @callelements[4] = (item/:city).inner_html + ", " + (item/:state).inner_html + " " + (item/:zip).inner_html
     @callelements[5] = (item/:country).inner_html 
     @email = (item/:email).inner_html 
    end
     
     if @callelements[5] == "USA"  
       @callelements[5] = "US"  
     end
    
    
#QRZ Screen Scraper    
#QRZ Changed Data Layout
    # doc = Hpricot(open("http://www.qrz.com/detail/#{params[:user][:login]}"))
    #   
    # #returns entire QRZ calldata table
    # @calldata = (doc/"#calldata").to_html
    # counter = 0
    # 
    # (doc/"tr/td").each do |td|
    #   if td.attributes['class'] == "q2" #csign #jq
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

    #if callsign not found return
    if @callelements[2] == nil or @callelements[2] == ""
      flash[:notice] = "Callsign not found in QRZ.com database or registration error encountered."
      respond_to do |wants|
        wants.html {redirect_to(:controller => 'accounts', :action => 'signup')}
        wants.iphone {redirect_to(:controller => 'home', :action => 'register')}
      end      
      
    else  

      u = User.new
      
      u.terms_of_service = params[:user][:terms_of_service]
      u.login = params[:user][:login]
      u.password = params[:user][:password]
      u.password_confirmation = params[:user][:password_confirmation]
      u.email = params[:user][:email]
      u.captcha = params[:user][:captcha] unless ENV['RAILS_ENV'] == 'test'
      u.captcha_answer = params[:user][:captcha_answer] unless ENV['RAILS_ENV'] == 'test'
    
      @u = u
      if u.save
        self.user = u
        
        #@tweet = u.login + " just signed up for 73s.org - " + "http://73s.org/profiles/" + u.id.to_s 
        @tweet = u.login + " just signed up for 73s.org - " + "http://73s.org/" + u.login
        twitter(@tweet)
        

        remember_me if params[:remember_me] == "1"
        flash[:notice] = "Thanks for signing up!"
        AuthMailer.deliver_registration(:subject=>"new #{SITE_NAME} registration", :body => "username = '#{@u.login}', email = '#{@u.profile.email}'", :recipients=>REGISTRATION_RECIPIENTS)
        # AuthMailer.deliver_registration(:subject=>"Welcome to #{SITE_NAME}!", :body => "#{@u.login}, Thanks for joining http://73s.org - the premier social network for ham radio operators online.  Please finish setting up your account by adding an avatar photo and a bio and by linking to your other Web 2.0 accounts such as YouTube and Flickr. Your new profile page can be accessed at http://73s.org/#{@u.login}. 73s!", :recipients => @u.profile.email)
        # redirect_to profile_url(@u.profile)
        redirect_to '/' + @u.login
      else  
        @user = @u
        params[:user][:password] = params[:user][:password_confirmation] = ''
        flash.now[:error] = @u.errors
        self.user = u# if RAILS_ENV == 'test'
      end
    end
  end
  
  

protected

  def remember_me
    self.user.remember_me
    cookies[:auth_token] = {
      :value => self.user.remember_token ,
      :expires => self.user.remember_token_expires_at
    }
  end
  
  
  def allow_to 
    super :all, :all=>true
  end
  
end



class AuthMailer < ActionMailer::Base
  def registration(options)
    self.generic_mailer(options)
  end
end