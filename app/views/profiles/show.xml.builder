
xml.instruct! :xml, :version=>"1.0"
  xml.callsign do
        xml.callsign @callsign
        xml.name @profile.full_name
        xml.email @email
        xml.website @website
        xml.location @profile.location
end

