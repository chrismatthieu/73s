
xml.instruct! :xml, :version=>"1.0"
  xml.qsos do
    @qsos.each do |qso|
      xml.qso do
        xml.callsign qso.callsign
        xml.name qso.name
        xml.email qso.email
        xml.country qso.country
        xml.state qso.state
        xml.city qso.city
        xml.frequency qso.frequency
        xml.signal qso.signal
        xml.event qso.event
        xml.notes qso.notes
        xml.pubDate qso.contacttime
      end
    end
end