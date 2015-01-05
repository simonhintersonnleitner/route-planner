class StatisticController < ApplicationController
  	def actual
  		
	 	#save
	 	#city = ReferenceCities.find(:name "Neunkirchen").take
	 	#render :text => city

	 	#getCheaptestPriceOfCity(city)
	end

	def history
		#save
	end
  	def save
  		
	 	@allCities = ReferenceCities.all()
	 	@allCitiesPrices = " "
	    for city in @allCities
	        @allCitiesPrices += " " + city.name + " " + getCheaptestPriceOfCity(city).to_s + ""
	    end

	end
	def getCheaptestPriceOfCity(city)

  		require 'net/http'

	  	uri = URI('http://www.spritpreisrechner.at/espritmap-app/GasStationServlet')

	  	lngNorthEast = city.lngNorthEast
	  	latNorthEast = city.latNorthEast

	  	lngSouthWest = city.lngSouthWest
	  	latSouthWest = city.latSouthWest


		dieselPrice = Net::HTTP.post_form(uri, "data" => "['','DIE','#{lngNorthEast}','#{latNorthEast}','#{lngSouthWest}','#{latSouthWest}']")
		petrolPrice = Net::HTTP.post_form(uri, "data" => "['','SUP','#{lngNorthEast}','#{latNorthEast}','#{lngSouthWest}','#{latSouthWest}']")

		if(dieselPrice.kind_of?(Net::HTTPSuccess))

			decode1 = ActiveSupport::JSON.decode(dieselPrice.body)
			decode2 = ActiveSupport::JSON.decode(petrolPrice.body)

			sum1 = 0
			sum2 = 0

			for i in 0..4
				sum1 += decode1[i]["spritPrice"][0]["amount"].to_f
				sum2 += decode2[i]["spritPrice"][0]["amount"].to_f
			end

			sum1 /= 5
			sum2 /= 5

			averageDiesel = sum1.round(3)
			averagePertrol = sum2.round(3)

			minDiesel = decode1[0]["spritPrice"][0]["amount"].to_f
			minPetrol = decode2[0]["spritPrice"][0]["amount"].to_f

			insert(city,minDiesel,minPetrol,averageDiesel,averagePertrol)

			return averageDiesel.to_s;
			#render :text => result
		end
		#render :text => res.body
	end
	def insert(city,minDiesel,minPetrol,averageDiesel,averagePertrol)
		priceDataset = PriceData.new
		priceDataset.cityFk = city.id
		priceDataset.minDiesel = minDiesel
		priceDataset.minPetrol = minPetrol
		priceDataset.averageDiesel = averageDiesel
		priceDataset.averagePertrol = averagePertrol
		priceDataset.save!

	end
	def getCityData
		 @prices = PriceData.where(cityFk: params[:cityId])
       	 render :json => @prices.to_json
	end
end
