module ListsHelper
  def iconx profile, size = :small, img_opts = {}
    #return "" if profile.nil?
    if profile != nil
      img_opts = {:title => profile.full_name, :alt => profile.full_name, :class => size}.merge(img_opts)
      #link_to(avatar_tag(profile, {:size => size, :file_column_version => size }, img_opts), profile_path(profile))
      link_to(avatar_tag(profile, {:size => size, :file_column_version => size }, img_opts), 'http://73s.org/' + profile.user.login)
    end
  end  

end
