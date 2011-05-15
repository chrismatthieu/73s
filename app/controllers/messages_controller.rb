class MessagesController < ApplicationController
  before_filter :can_send, :only => :create
  
  
  def index
    @message = Message.new
    @to_list = @p.friends
    
    if @p.received_messages.empty? && @p.has_network?
      flash[:notice] = 'You have no mail in your inbox.  Try sending a message to someone.'
      @to_list = (@p.followers + @p.friends + @p.followings)
      redirect_to new_profile_message_path(@p) and return
    end
  end
  
  def create
    @message = @p.sent_messages.create(params[:message]) 
    
    #notify user that someone left them a direct message
    #via email
    @toprofile = Profile.find(:first, :conditions => ["user_id = ?", params[:message][:receiver_id]])
    MessageMailer.deliver_registration(:subject=>"You Have Mail @ #{SITE_NAME}", :body => "#{@u.login.upcase} just sent you a message.  It can be retrieved from http://73s.org/#{@toprofile.user.login}.", :recipients=>@toprofile.email)
    #via twitter
    # @tweet = "d #{@toprofile.twitter_name} you have a message waiting at http://73s.org/#{@toprofile.user.login}" 
    # twitter(@tweet)
    
    
    respond_to do |wants|
      if @message.new_record?
        wants.js do
          render :update do |page|
            page.alert @message.errors.to_s
          end
        wants.iphone { redirect_to :action => "index" }
          
        end
      else
        wants.iphone { redirect_to :action => "index"  }
        
        wants.js do
          render :update do |page|
            # page.alert "Message sent."
            page << "jq('#message_subject, #message_body').val('');"
            page << "tb_remove()"
          end
        end
      end
    end
  end
  
  def new
    @message = Message.new
    @to_list = (@p.followers + @p.friends + @p.followings)
    render
  end
  
  def nudge
    #nudge a user to participate 
    @toprofile = Profile.find(:first, :conditions => ["user_id = ?", params[:message][:receiver_id]])
    MessageMailer.deliver_registration(:subject=>"#{SITE_NAME} Nudge from #{@u.login.upcase}", :body => "#{@u.login.upcase} is requesting that you return to http://73s.org/#{@toprofile.user.login} to participate.  Here's their message: #{params[:nudge][:message]}", :recipients=>@toprofile.email)
    render :update do |page|
      page.alert "Message sent."
      page << "jq('#message_subject, #message_body').val('');"
      page << "tb_remove()"
    end
  end
  
  def sent
    @message = Message.new
    @to_list = @p.friends
  end
  
  def show
    @message = @p.sent_messages.find params[:id] rescue nil
    @message ||= @p.received_messages.find params[:id] rescue nil
    @to_list = [@message.sender]
    if @message 
      @message.read = true
      @message.save
    end
  end
  
  def reply
    render
  end
  
  # DELETE /messages/1
  # DELETE /messages/1.xml
  def destroy
    @message = Message.find(params[:id])
    @message.destroy
  
    respond_to do |format|
      format.html { redirect_to(messages_url) }
      format.xml  { head :ok }
      format.iphone { redirect_to :action => "index" }
      
    end
  end



  protected
  def allow_to
    super :user, :all => true
  end
  
  def can_send
    render :update do |page|
      page.alert "Sorry, you can't send messages."
    end unless @p.can_send_messages
  end
  
end

class MessageMailer < ActionMailer::Base
  def registration(options)
    self.generic_mailer(options)
  end
end