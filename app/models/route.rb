class Route < ActiveRecord::Base

  require 'open-uri'

  @@url = 'http://maps.googleapis.com/maps/api/directions/json'

  after_initialize do |route|
    # count up hits by 1
    if route.hits == nil  
      route.hits = 1
    else 
      route.hits += 1
    end

    route.get_data if path == nil
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

    # update data
    update_data(json)

  end

  def update_data(json)
    
    if get_status(json) == "OK"
      set_distance(json["routes"][0]["legs"][0]["distance"]["value"])
      set_time(json["routes"][0]["legs"][0]["duration"]["value"])
      set_path(json["routes"][0]["overview_polyline"]["points"])
    end
  
  end

  def set_distance(distance)
    self.distance = distance
  end

  def set_time(time)
    self.time = time
  end

  def set_path(path)
    self.path = path
  end

  def get_status(json)
    json["status"]
  end

end
