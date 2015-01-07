class PriceData < ActiveRecord::Base

  def self.get_cheaptest_diesel_price
    min = self.minimum(:min_diesel)
    return self.where(min_diesel: min).last
  end
  def self.get_cheaptest_super_price
    min = self.minimum(:min_super)
    return self.where(min_super: min).last
  end
  def self.get_priciest_diesel_price
    max = self.maximum(:max_diesel)
    return self.where(max_diesel: max).last
  end
   def self.get_priciest_super_price
    max = self.maximum(:max_super)
    return self.where(max_super: max).last
  end
   def self.get_cheaptest_diesel_price_by_day
    min =  self.all.where(created_at: (Time.now.midnight)..(Time.now)).minimum(:min_diesel)
    return  self.where(min_diesel: min).last
  end
  def self.get_cheaptest_super_price_by_day
     min =  self.all.where(created_at: (Time.now.midnight)..(Time.now)).minimum(:min_super)
    return self.where(min_super: min).last
  end
  def self.get_priciest_diesel_price_by_day
     max =  self.all.where(created_at: (Time.now.midnight)..(Time.now)).maximum(:max_diesel)
    return self.where(max_diesel: max).last
  end
  def self.get_priciest_super_price_by_day
    max =  self.all.where(created_at: (Time.now.midnight)..(Time.now)).maximum(:max_super)
    return self.where(max_super: max).last
  end

  def self.clean
    count = 0
    cities = ReferenceCities.all()
    for city in cities
      prices = self.where(city_fk: city.id)
      priceBefore = prices[0]
      for i in 1..prices.length-1
        date1 = DateTime.parse(prices[i].updated_at.to_s)
        date2 = DateTime.parse(priceBefore.updated_at.to_s)
        if(prices[i].min_diesel == priceBefore.min_diesel && 
          prices[i].min_super == priceBefore.min_super && 
          prices[i].average_diesel == priceBefore.average_diesel &&
          prices[i].average_super == priceBefore.average_super && 
          date1.wday == date2.wday)
          priceBefore.destroy
        count += 1;
        end
        priceBefore = prices[i];
      end 
    end
    return count.to_s + " datasets deleted"
  end

end


