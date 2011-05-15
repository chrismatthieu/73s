
xml.instruct! :xml, :version=>"1.0"
  xml.callsign do
        xml.callsign @callsign
        xml.name @callelements[2]
        xml.location @callelements[5]
        xml.lat @lat
        xml.lon @lon
end

 