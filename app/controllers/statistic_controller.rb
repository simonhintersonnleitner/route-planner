class StatisticController < ApplicationController
  	def show
  		
	 	@allCities = ReferenceCities.all()
	 	@allCitiesPrices = " "
	    for city in @allCities
	        @allCitiesPrices += " "+city.name + " " + getCheaptestPriceOfCity(city).to_s + ""
	    end

	end
	def getCheaptestPriceOfCity(city)

  		require 'net/http'

	  	uri = URI('http://www.spritpreisrechner.at/espritmap-app/GasStationServlet')

	  	lngNorthEast = city.lngNorthEast
	  	latNorthEast = city.latNorthEast

	  	lngSouthWest = city.lngSouthWest
	  	latSouthWest = city.latSouthWest


		res = Net::HTTP.post_form(uri, "data" => "['','DIE','#{lngNorthEast}','#{latNorthEast}','#{lngSouthWest}','#{latSouthWest}']")


		decode = ActiveSupport::JSON.decode(res.body)

		sum1 = 0
		
		for i in 0..0
			sum1 += decode[i]["spritPrice"][0]["amount"].to_f
		end

		sum1 /= 1


		return sum1.to_s;
		#render :text => result

		#render :text => res.body
	end
end
