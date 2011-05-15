class QsosController < ApplicationController
  skip_before_filter :login_required	
  
def index
  @user = User.find(:first, :conditions => ['login = ?', params[:id]])
  if @user 
    if params[:month] == "*"
      params[:month] = ''
    end
    if params[:year] == "*"
      params[:year] = ''
    end
    if params[:contact] == "*"
      params[:contact] = ''
    end


    if params[:month] != nil
      @qsos = Contact.find(:all, :conditions => ['profile_id = ? and callsign LIKE ? and contacttime LIKE ?', @user.id, '%' + params[:contact] + '%', '%' + params[:year] + '-' + params[:month]  + '%'])
    elsif params[:year] != nil
      @qsos = Contact.find(:all, :conditions => ['profile_id = ? and callsign LIKE ? and contacttime LIKE ?', @user.id, '%' + params[:contact] + '%', '%' + params[:year] + '%'])
    elsif params[:contact] != nil
      @qsos = Contact.find(:all, :conditions => ['profile_id = ? and callsign LIKE ?', @user.id, '%' + params[:contact] + '%'])
    else
      @qsos = Contact.find(:all, :conditions => ['profile_id = ?', @user.id])
    end
  end
  
  respond_to do |format|
    #format.html # index.html.erb
    format.xml  {render :layout=>false}
  end

end


private

def allow_to 
  super :all, :all=>true
end


end
