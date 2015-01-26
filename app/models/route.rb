class Route < ActiveRecord::Base

  require 'open-uri'

  has_and_belongs_to_many :users

  @@url = 'http://maps.googleapis.com/maps/api/directions/json'

  after_initialize do |route|
    self.increment!(:hits)
    route.get_data 
  end

  def get_data
    
    options = {
      :language => :de,
      :alternative => :true,
      :sensor => :false,
      :mode => :driving,
      :origin => self.origin, 
      :destination => self.destination
    }

    # API Call
    result = open(@@url + "?" + options.to_query).read
    json = JSON.parse(result)

    # Daten updaten
    update_data(json)

  end

  def update_data(json)
    
    if json["status"] == "OK"
      self.distance = json["routes"][0]["legs"][0]["distance"]["value"]
      self.time = json["routes"][0]["legs"][0]["duration"]["value"]
      self.path = Polylines::Decoder.decode_polyline json["routes"][0]["overview_polyline"]["points"]
      self.bounds = json["routes"][0]["bounds"]
    end
  
  end

end
