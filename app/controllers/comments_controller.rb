class CommentsController < ApplicationController
  skip_filter :store_location, :only => [:create, :destroy]
  before_filter :setup
  
  
  def index
    @comments = Comment.between_profiles(@p, @profile).paginate(:page => @page, :per_page => @per_page)
    redirect_to @p and return if @p == @profile if @p == @profile
    respond_to do |wants|
      wants.html {render}
      wants.rss {render :layout=>false}
    end
  end
  
  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    if @comment.profile_id == @p.id
      @comment.destroy
    end
    
    respond_to do |format|
      format.html { redirect_to("/") }
      format.xml  { head :ok }
    end
  end
  
  
  def create
    @comment = @parent.comments.new(params[:comment].merge(:profile_id => @p.id))
    
    #email user about wall or blog comment
    if params[:blog_id] != nil
      @toblog = Blog.find(params[:blog_id])
      MessageMailer.deliver_registration(:subject=>"#{@p.user.login.upcase} Added Comment to Your #{SITE_NAME} Blog", :body => "You can view your new comment at http://73s.org/#{@toblog.profile.user.login}/blog/#{params[:blog_id]}", :recipients=>@toblog.profile.email)
    else
      # @toprofile = Profile.find(:first, :conditions => ["user_id = ?", params[:profile_id]])
      # @toprofile = Profile.find(:first, :conditions => ["id = ?", params[:profile_id]])
      @toprofile = @profile
      MessageMailer.deliver_registration(:subject=>"#{@p.user.login.upcase} Added Comment to Your #{SITE_NAME} Wall", :body => "You can view your new comment at http://73s.org/#{@toprofile.user.login rescue ''}", :recipients=>@toprofile.email)
    end 
    
    respond_to do |wants|
      if @comment.save
        wants.js do
          render :update do |page|
            page.insert_html :top, "#{dom_id(@parent)}_comments", :partial => 'comments/comment', :object => @comment
            page.visual_effect :highlight, "comment_#{@comment.id}".to_sym
            page << 'tb_remove();'
            page << "jq('#comment_comment').val('');"
            # page.alert "Comment added."
          end
        end
      else
        wants.js do
          render :update do |page|
            page << "message('Oops... I could not create that comment');"
          end
        end
      end
    end
  end
  
  protected
    
    def parent; @blog || @profile || nil; end
    
    def setup
      @profile = Profile[params[:profile_id]] if params[:profile_id]
      @user = @profile.user if @profile
      @blog = Blog.find(params[:blog_id]) unless params[:blog_id].blank?
      @parent = parent
    end
  
    def allow_to
      super :user, :only => [:index, :create, :destroy]
    end

end


class MessageMailer < ActionMailer::Base
  def registration(options)
    self.generic_mailer(options)
  end
end