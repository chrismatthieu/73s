
xml.instruct! :xml, :version=>"1.0"
xml.rss(:version=>"2.0") do
  xml.channel do
    xml.title "73s.org Status Updates"
    xml.link SITE
    xml.description "I can feel it in the air tonight at #{SITE_NAME}"
    xml.language 'en-us'
    @statuses.each do |status|
      xml.item do
        xml.title status.profile.user.login.upcase + " Status"
        xml.description status.message
        xml.author status.profile.user.login.upcase
        xml.pubDate status.created_at
        xml.link "http://" + SITE + "/" + status.profile.user.login + "/mystatus/"
        xml.guid "http://" + SITE + "/" + status.profile.user.login + "/mystatus/" 
      end
    end
  end
end