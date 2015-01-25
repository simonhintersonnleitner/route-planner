class Route < ActiveRecord::Base

  require 'open-uri'
  has_and_belongs_to_many :users

  @@url = 'http://maps.googleapis.com/maps/api/directions/json'

  after_initialize do |route|

    route.count_up

    route.get_data if path == nil || bounds == nil
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

    weather = Weather::get_weather()

    # update data
    update_data(json)

  end

  def update_data(json)
    
    if get_status(json) == "OK"
      set_distance(json["routes"][0]["legs"][0]["distance"]["value"])
      set_time(json["routes"][0]["legs"][0]["duration"]["value"])
      set_path(json["routes"][0]["overview_polyline"]["points"])
      set_bounds(json["routes"][0]["bounds"])
    end
  
  end

  def set_distance(distance)
    self.distance = distance
  end

  def set_bounds(bounds)
    self.bounds = bounds  
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

  def count_up
    # count up hits by 1
    if self.hits == nil  
      self.hits = 1
    else 
      self.hits += 1
    end

    self.save

  end

end
