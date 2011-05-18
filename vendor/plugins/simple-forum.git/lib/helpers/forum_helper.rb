# require 'avatar/view/action_view_support'

module ForumHelper
  
  # include Avatar::View::ActionViewSupport
  
  
  def forum_session
    @forum_session ||= ForumSession.new(session)
  end
 
  def moderator_actions_for(forum, &block)
    if forum.moderators.include? @u
      yield
    end
  end

  def last_post_info(object)
    s = []
    s << object.last_post_at.strftime("%d-%m-%Y %H:%M") if object.last_post_at
    s << "for" if object.last_post_by
    s << link_to(h(object.last_poster.login), object.last_poster) if object.last_poster
    s * "&nbsp;"
  end

  def avatar_url_for(user, options = {})
    #return "" unless user.respond_to? "email"

    %(http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(user.profile.email)}.jpg?s=#{options[:size] || 80}) rescue ""
  end
  
  
  def icon profile, size = :small, img_opts = {}
    #return "" if profile.nil?
    if profile != nil
      img_opts = {:title => profile.full_name, :alt => profile.full_name, :class => size}.merge(img_opts)
      #link_to(avatar_tag(profile, {:size => size, :file_column_version => size }, img_opts), profile_path(profile))
      # link_to(avatar_tag(profile, {:size => size, :file_column_version => size }, img_opts), '/' + profile.user.login)
    end
  end
  
  include ActionView::Helpers::AssetTagHelper
 
  def image profile, size = :square, img_opts = {}
    return image_tag(image_path( profile, size), :class => size) if profile.icon.blank?
    img_tag = image_tag(profile_path( profile, size), {:title=>profile.user.login, :alt=>profile.user.login, :class=>size}.merge(img_opts))
    img_tag
  end
  
  def profile_path profile = nil, size = :square
    path = nil
    unless profile.nil? || profile.icon.blank?
      path = url_for_file_column(profile, :icon, size.to_s) rescue nil
    end
    path = missing_profile_path(size) if path.nil?
    return path
  end
 
  def allowed_profile_sizes
    [:square, :small]
  end
 
  def missing_profile_path(size)
    if allowed_profile_sizes.include?(size)
      "/images/missing_#{size}.png"
    else
      '/images/missing.png'
    end
  end
 
  def image_path_with_profile(source_or_profile, size = :square)
    source_or_profile.respond_to?(:icon) ? profile_path(source_or_profile, size) : image_path_without_profile(source_or_profile)
  end
  alias_method_chain :image_path, :profile
  
  
  
  
end
