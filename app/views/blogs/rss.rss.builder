xml.instruct! :xml, :version=>"1.0"
xml.rss(:version=>"2.0") do
  xml.channel do
    xml.title "73s.org's Blogs"
    xml.link SITE
    xml.description "All user blogs at #{SITE_NAME} - the ham radio social network"
    xml.language 'en-us'
    @blogs.each do |blog|
      xml.item do
        xml.title blog.title
        xml.description blog_body_content(blog)
        xml.author "#{blog.profile.f}"
        xml.pubDate blog.created_at
        xml.link "http://" + SITE + "/" + blog.profile.user.login + "/blog/" + blog.id.to_s
        xml.guid "http://" + SITE + "/" + blog.profile.user.login + "/blog/" + blog.id.to_s
      end
    end
  end
end