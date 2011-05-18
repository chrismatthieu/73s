# require 'avatar/view/action_view_support'

module ProfilesHelper
  # include Avatar::View::ActionViewSupport
  
  def icon profile, size = :small, img_opts = {}
    #return "" if profile.nil?
    if profile != nil
      img_opts = {:title => profile.full_name, :alt => profile.full_name, :class => size}.merge(img_opts)
      #link_to(avatar_tag(profile, {:size => size, :file_column_version => size }, img_opts), profile_path(profile))
      # link_to(avatar_tag(profile, {:size => size, :file_column_version => size }, img_opts), '/' + profile.user.login)
    end
  end
  
  def location_link profile = @p
    return profile.location if profile.location == Profile::NOWHERE
    link_to h(profile.location), search_profiles_path.add_param('search[location]' => profile.location)
  end

  def status_counter
     update_page do |page|
        page << "$('counter_box').innerHTML = 150 - $('status_input_box').value.length"
     end
  end

end
