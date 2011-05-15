class FeedItemsController < ApplicationController
  skip_filter :store_location
  before_filter :setup, :except=>[:summary]
  skip_before_filter :login_required, :only=>[:summary]

  def destroy
    @profile.feeds.find(:first, :conditions => {:feed_item_id=>params[:id]}).destroy
    
    respond_to do |wants|
      wants.html do
        flash[:notice] = 'Item successfully removed from the recent activities list.'
        redirect_back_or_default @profile
      end
      wants.js { render(:update){|page| page.visual_effect :puff, "feed_item_#{params[:id]}".to_sym}}
    end
  end
  
  def summary
    # @reporton = Profile.find(:first, :conditions => ['id = ?', params[:id]])
    @reportons = Profile.find(:all, :conditions => ['supresssummary != true and user_id <> ""'])

    for reporton in @reportons
    @reports = reporton.feed_items
    feedsfound = false
    
    unless @reports.nil? or @reports.empty? 

        message = "Your daily 73s network activity is listed below: \n\n"
        
    		@reports.each do |feed_item| 
    		next unless feed_item.item and feed_item.created_at > 1.days.ago
        
        feedsfound = true
        
    		if feed_item.partial == 'blog'
    			blog ||= feed_item.item 
    			message << blog.profile.f + '( http://73s.org/' + blog.profile.user.login + ' ) blogged at http://73s.org/' + blog.profile.user.login + '/blogs'

    		elsif feed_item.partial == 'comment'
    			comment ||= feed_item.item
    		  parent = comment.commentable
    		  if parent.class.name == 'Profile' 
    		    message << comment.profile.user.login + ' ( http://73s.org/' + comment.profile.user.login + ' ) wrote a comment on ' + parent.f+'\'s ( http://73s.org/' + parent.user.login + ' ) wall' 
    		  elsif parent.class.name == 'Blog' 
            # message << comment.profile.user.login + ' ( http://73s.org/' + comment.profile.user.login + ' ) commented on http://73s.org' + profile_blog_path(parent.profile, parent) 
    		    message << comment.profile.user.login + ' ( http://73s.org/' + comment.profile.user.login + ' ) commented on http://73s.org/' + parent.profile.user.login + '/blog/' + parent.id.to_s
    		  end
    		  
    		elsif feed_item.partial == 'friend'
    			feed_item ||= @feed_item
    			friendship = feed_item.item
    			inviter = friendship.inviter
    			invited = friendship.invited
    			
    	    message <<  inviter.f + ' ( http://73s.org/' + inviter.user.login + ' ) is now a ' + friendship.description(inviter) + ' of ' + invited.f + ' ( http://73s.org/' + invited.user.login + ' )' 

    		elsif feed_item.partial == 'photo'
    			p = feed_item.item 
    			message << p.profile.f + ' ( http://73s.org/' + p.profile.user.login + ' ) uploaded a new ' + p.caption + ' photo at http://73s.org/' + p.profile.user.login #image_path(p, nil) 

    		elsif feed_item.partial == 'status'
    			p = feed_item.item 
    			message << p.profile.f + ' ( http://73s.org/' + p.profile.user.login + ' ) updated status ' + p.message + ' at http://73s.org/' + p.profile.user.login + '/mystatus '

    		elsif feed_item.partial == 'forumtopic'
    			p = feed_item.item 
    			topic = ForumTopic.find(:first, :conditions => ['id = ?', p])
          profile = Profile.find(:first, :conditions => ['user_id = ?', topic.user_id])
          # link_to h(profile.f), profile %> started new forum topic <%= time_ago_in_words topic.created_at %> ago <%= link_to sanitize(textilize(topic.title)), '/forums/' + topic.forum_id.to_s + '/topics/' + topicid.id.to_s %>
    			message << profile.f + ' ( http://73s.org/' + profile.user.login + ' ) started new forum topic ' + sanitize(textilize(topic.title)) + ' at http://73s.org/forums/' + topic.forum_id.to_s + '/topics/' + topicid.id.to_s
 
    		elsif feed_item.partial == 'list'
          # p = feed_item.item 
          
    			profile = Profile.find(:first, :conditions => ["id = ?", feed_item.item.user_id])
    			message << profile.f + ' ( http://73s.org/' + profile.user.login + ' ) added new gear to their list at http://73s.org/' + profile.user.login + '/gear '

    		end 
    		message << "\n\n"
    	end 
      
      message << "\nTo unsubscribe to these network activity updates log into http://73s.org and click on dashboard (under the search box) and account settings and then check the stop sending email box and save\n\n73s,\nChris ~ N7ICE\n\n"
      
      if feedsfound == true
        #via email
        FeedMailer.deliver_registration(:subject=>"Daily #{SITE_NAME} Network Activity", :body => message, :recipients=>reporton.email)
      end
      
    end   
    end 
    
    render :layout => false
    
  end
   
  
  protected
  
  def allow_to
    # super :user, :only => [:destroy]
    super :all, :all=>true
  end
  
  def setup
    @profile = Profile[params[:profile_id]]
    if @p != @profile
      respond_to do |wants|
        wants.html do
          flash[:notice] = "Sorry, you can't do that."
          redirect_back_or_default @profile
        end
        wants.js { render(:update){|page| page.alert "Sorry, you can't do that."}}
      end
    end
  end
end

class FeedMailer < ActionMailer::Base
  def registration(options)
    self.generic_mailer(options)
  end
end