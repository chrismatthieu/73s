require 'hpricot'

xml.instruct! :xml, :version=>"1.0"
	xml.RelationViewerData do
  		xml.Settings(:appTitle => 'QSO Graph', :WWWLinkTargetFrame => '_blank', :startID => "#{@callsign.downcase}",  :defaultRadius => '170', :maxRadius => '240', :contextRadius => '230') do 

			xml.RelationTypes do
				xml.DirectedRelation(:color=>"0x999999", :lineSize=>"3")		
				xml.UndirectedRelation(:color=>"0x999999", :lineSize=>"3")
			end
			xml.NodeTypes do
				xml.Person
			end
		end
		
		xml.Nodes do
		  for user in @users
		    doc = Hpricot(avatar_tag(user.profile))
        xml.Person(:id=>"#{user.login.downcase}", :name=>"#{user.login.downcase}", :hops=>"", :imageURL=>"#{doc.search('img').first[:src]}", :linkURL=>"http://73s.org/#{user.login}")
      end
		  for contact in @contacts
        xml.Person(:id=>"#{contact.callsign.downcase}", :name=>"#{contact.callsign.downcase}", :hops=>"", :imageURL=>"", :linkURL=>"http://73s.org/#{contact.callsign.downcase}")
        # xml.Person(:id=>"n7ice", :name=>"n7ice", :hops=>"", :imageURL=>"http://lijit.com/files/pictures/picture-32.png", :linkURL=>"http://lijit.com/users/der_mo")
        # xml.Person(:id=>"k7dig", :name=>"k7dig", :hops=>"", :imageURL=>"http://lijit.com/files/pictures/picture-32.png", :linkURL=>"http://lijit.com/users/der_mo")
      end
		end
		
		xml.Relations do
		  for contact in @contacts
  			xml.DirectedRelation(:fromID=>"#{contact.profile.user.login.downcase}", :quality=>"50", :toID=>"#{contact.callsign.downcase}")
  			#xml.DirectedRelation(:fromID=>"#{contact.callsign.downcase}", :quality=>"50", :toID=>"#{contact.profile.user.login.downcase}")
        # xml.DirectedRelation(:fromID=>"n7ice", :quality=>"50", :toID=>"k7dig")
        # xml.DirectedRelation(:fromID=>"k7dig", :quality=>"50", :toID=>"n7ice")
      end
		end
		
	end

