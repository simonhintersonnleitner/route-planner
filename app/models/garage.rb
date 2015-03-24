class Garage < ActiveRecord::Base

  require 'net/http'
  @@url = URI('http://www.spritpreisrechner.at/espritmap-app/GasStationServlet')

  def self.get_garages_by_path(path)
    
    array = path.split(",")
    json = nil
    types = ["DIE","SUP"]
    garages = []

    types.each do |t|

      for i in 0..array.count
        # Nur jeder 2. Eintrag, weil lat,long,lat,long, ...
        next if i.odd?

        response = Net::HTTP.post_form(@@url, "data" => "['','#{t}','#{array[i+1]}','#{array[i]}','#{array[i+1]}','#{array[i]}']")
        json = ActiveSupport::JSON.decode(response.body)

        for i in 0..3
          if(json[i] != nil) 
            if json[i]["distance"].to_f <= 5
              # Neue Tankstelle erstellen, falls noch nicht existiert
              
              # Doesn't work :(
              #Rails.cache.fetch("#{json[i]["latitude"]}/#{json[i]["longitude"]}", :expires_in => 2.hours) do
                garage = Garage.find_or_create_by(lat: json[i]["latitude"], lng: json[i]["longitude"])
                garage.update_data json[i],t
              #end
              garages.push garage

            end
          end

        end

      end

    end

    # Doppelte Tankstellen herausfiltern (Diesel/Benzin)
    garages = garages.uniq {|o| o.id}

  end

  def update_data ( json, type )
      if(type == 'DIE')
        self.price_die = json["spritPrice"][0]["amount"].to_f if json["spritPrice"][0] != nil
      elsif(type == 'SUP')
        self.price_sup = json["spritPrice"][0]["amount"].to_f if json["spritPrice"][0] != nil
      end

      self.address = json["address"] if self.address != json["address"]
      self.opening = json["openingHours"] if self.opening != json["openingHours"]
      self.description = json["serviceText"] if self.description != json["serviceText"]
      self.name = json["gasStationName"] if self.name != json["gasStationName"]
      self.open = json["open"]

      self.save

  end

end