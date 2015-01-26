class Garage < ActiveRecord::Base

  def update_data ( json, type )
    # if self.name == nil
    # name setzen
      if(type == 'DIE')
        self.price_die = json["spritPrice"][0]["amount"].to_f if json["spritPrice"][0] != nil
      elsif(type == 'SUP')
        self.price_sup = json["spritPrice"][0]["amount"].to_f if json["spritPrice"][0] != nil
      end

      self.address = json["address"]
      self.opening = json["openingHours"]
      self.description = json["serviceText"]
      self.name = json["gasStationName"]
      self.open = json["open"]

      self.save

  end

end
