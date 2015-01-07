class Garage < ActiveRecord::Base

  def update_data ( json, type )
    # if self.name == nil
    # name setzen
      if(type == 'DIE')
        self.price_die = json["spritPrice"][0]["amount"].to_f
      elsif(type == 'SUP')
        self.price_sup = json["spritPrice"][0]["amount"].to_f
      end

      self.description = json["address"]

      self.save

  end

end
