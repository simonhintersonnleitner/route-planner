class PriceData < ActiveRecord::Base

  def self.get_cheaptest_diesel_price
    min = self.minimum(:minDiesel)
    return self.where(minDiesel: min).take
  end
  def self.get_cheaptest_petrol_price
    min = self.minimum(:minPetrol)
    return self.where(minPetrol: min).take
  end
  def self.get_priciest_diesel_price
    max = self.maximum(:minDiesel)
    return self.where(minDiesel: max).take
  end
   def self.get_priciest_petrol_price
    max = self.maximum(:minPetrol)
    return self.where(minPetrol: max).take
  end

  def self.clean
    count = 0
    cities = ReferenceCities.all()
    for city in cities
      prices = self.where(cityFk: city.id)
      priceBefore = prices[0]
      for i in 1..prices.length-1
        date1 = DateTime.parse(prices[i].updated_at.to_s)
        date2 = DateTime.parse(priceBefore.updated_at.to_s)
        if(prices[i].minDiesel == priceBefore.minDiesel && 
          prices[i].minPetrol == priceBefore.minPetrol && 
          prices[i].averageDiesel == priceBefore.averageDiesel &&
          prices[i].averagePertrol == priceBefore.averagePertrol && 
          date1.wday == date2.wday)
          priceBefore.destroy
        count += 1;
        end
        priceBefore = prices[i];
      end 
    end
    return count
  end

end


