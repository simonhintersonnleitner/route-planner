class StatisticController < ApplicationController
	require 'net/http'

	def actual
	
	end

	def history
		
	end

	def weekday
		
	end

	def reference

	end

	def minMax
				#save_price_for_all_cities
				#render :json => 				PriceData.clean
				#render :json => PriceData.get_cheaptest_petrol_price
	end

	def save
		render :text => save_price_for_all_cities
	end

	def clean
		render :text => PriceData.clean
	end

	def save_price_for_all_cities
		count = 0
		for city in ReferenceCities.all()
    	save_price_of_city(city)
    	count += 1
		end
		return count.to_s + " datasets added"  
	end

	def save_price_of_city(city)
	
		#render :text => decode1[0]["errorItems"][0]["msgText"]

		response_diesel = get_response_from_api(city,"DIE")
		response_super = get_response_from_api(city,"SUP")

		insert(city,get_min(response_diesel),get_min(response_super),get_average(response_diesel),get_average(response_super),get_max(response_diesel),get_max(response_super))

	end

	def get_response_from_api(city,type)
		uri = URI('http://www.spritpreisrechner.at/espritmap-app/GasStationServlet')

		lng_north_east = city.lng_north_east
		lat_north_east = city.lat_north_east

		lng_south_west = city.lng_south_west
		lat_south_west = city.lat_south_west

		respone = Net::HTTP.post_form(uri, "data" => "['','#{type}','#{lng_north_east}','#{lat_north_east}','#{lng_south_west}','#{lat_south_west}']")

		return ActiveSupport::JSON.decode(respone.body)

	end

	def get_average(respone)
		sum = 0

		for i in 0..4
			sum += respone[i]["spritPrice"][0]["amount"].to_f
		end

		sum /= 5

		return sum.round(3)
	end

	def get_min(respone)
		return respone[0]["spritPrice"][0]["amount"].to_f
	end

	def get_max(respone)
		return respone[4]["spritPrice"][0]["amount"].to_f
	end

	def insert(city,min_diesel,min_super,average_diesel,average_super,max_diesel,max_super)
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

	def get_city_prices_by_id
		if(params[:cityId] == "all")
			prices = PriceData.all()
		else
			prices = PriceData.where(city_fk: params[:cityId])
		end	
		render :json => prices.to_json
	end

	def get_city_price_per_weekday_by_id

    #calculate average for each weekdays
    if(params[:cityId] == "all")
      prices = PriceData.all()
    else
      prices = PriceData.where(city_fk: params[:cityId])
    end 

    sum_diesel = Array.new(14, 0)
    sum_super = Array.new(14, 0)
    
    for price in prices
      d = DateTime.parse(price.updated_at.to_s)
      sum_diesel[d.wday] += price.average_diesel
      sum_diesel[d.wday+7] += 1
      sum_super[d.wday] += price.average_super
      sum_super[d.wday+7] += 1
    end

    #create json response object
    price_per_weekday = Array.new(7,0)

    for i in 0..6
        if sum_diesel[i+7] != 0
          price_per_weekday[i] = {
          :weekday => i,
          :average_diesel => ((sum_diesel[i])/sum_diesel[i+7]).round(3),
          :average_super => ((sum_super[i])/sum_super[i+7]).round(3)}
        else
          price_per_weekday[i] = {
          :weekday => i,
          :average_diesel => 0,
          :average_super => 0}
        end
    end
    
    render :json => price_per_weekday  

  end
end
