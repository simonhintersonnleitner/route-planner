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

  def self.save_price_for_all_cities
    count = 0
    ReferenceCities.all().each do |city|
      save_price_of_city(city)
      count += 1
    end

    return count.to_s + " datasets added"  
  end

  def self.save_price_of_city(city)
  
    #render :text => decode1[0]["errorItems"][0]["msgText"]

    response_diesel = get_response_from_api(city,"DIE")
    response_super = get_response_from_api(city,"SUP")

    insert(city,get_min(response_diesel),get_min(response_super),get_average(response_diesel),get_average(response_super),get_max(response_diesel),get_max(response_super))

  end

  def self.get_response_from_api(city,type)
    uri = URI('http://www.spritpreisrechner.at/espritmap-app/GasStationServlet')

    lng_north_east = city.lng_north_east
    lat_north_east = city.lat_north_east

    lng_south_west = city.lng_south_west
    lat_south_west = city.lat_south_west
    

    respone = Net::HTTP.post_form(uri, "data" => "['','#{type}','#{lng_north_east}','#{lat_north_east}','#{lng_south_west}','#{lat_south_west}']")

    return ActiveSupport::JSON.decode(respone.body)

  end

  def self.get_average(respone)
    sum = 0

    for i in 0..4
      sum += respone[i]["spritPrice"][0]["amount"].to_f
    end

    sum /= 5

    return sum.round(3)
  end

  def self.get_min(respone)
    return respone[0]["spritPrice"][0]["amount"].to_f
  end

  def self.get_max(respone)
    return respone[4]["spritPrice"][0]["amount"].to_f
  end

  def self.insert(city,min_diesel,min_super,average_diesel,average_super,max_diesel,max_super)
    priceDataset = PriceData.new
    priceDataset.city_fk = city.id
    priceDataset.min_diesel = min_diesel
    priceDataset.min_super = min_super
    priceDataset.average_diesel = average_diesel
    priceDataset.average_super = average_super
    priceDataset.max_diesel = max_diesel
    priceDataset.max_super = max_super
    priceDataset.save!
  end
end


