module ReviewsHelper
  include Avatar::View::ActionViewSupport
  
  def icon profile, size = :small, img_opts = {}
    #return "" if profile.nil?
    if profile != nil
      img_opts = {:title => profile.full_name, :alt => profile.full_name, :class => size}.merge(img_opts)
      link_to(avatar_tag(profile, {:size => size, :file_column_version => size }, img_opts), '/' + profile.user.login)
    end
  end
end
