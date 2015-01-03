class StatisticController < ApplicationController
  	def show
  		
		@Bregenz = getAmmountOfCity("Bregenz")
		@Innsbruck = getAmmountOfCity("Innsbruck")
		@Salzburg = getAmmountOfCity("Salzburg")
		@Klagenfurt = getAmmountOfCity("Klagenfurt")
		@Linz = getAmmountOfCity("Linz")
		@Graz = getAmmountOfCity("Graz")
		@Eisenstadt = getAmmountOfCity("Eisenstadt")
		@StPoelten = getAmmountOfCity("StPoelten")
		@Wien = getAmmountOfCity("Wien")

	end
	def getAmmountOfCity(city)

  		require 'net/http'

	  	uri = URI('http://www.spritpreisrechner.at/espritmap-app/GasStationServlet')
	  	uri2 = 'http://maps.googleapis.com/maps/api/geocode/json?address=' + city

		result = Net::HTTP.get(URI.parse(URI.encode(uri2)))

		decode = ActiveSupport::JSON.decode(result)

		latNorthEast = decode["results"][0]["geometry"]["bounds"]["northeast"]["lat"]
		lngNorthEast = decode["results"][0]["geometry"]["bounds"]["northeast"]["lng"]

		latSouthWest = decode["results"][0]["geometry"]["bounds"]["southwest"]["lat"]
		lngSouthWest = decode["results"][0]["geometry"]["bounds"]["southwest"]["lng"]

		res1 = Net::HTTP.post_form(uri, "data" => "['','DIE','#{lngNorthEast}','#{latNorthEast}','#{lngSouthWest}','#{latSouthWest}']")


		decode1 = ActiveSupport::JSON.decode(res1.body)

		sum1 = 0
		
		for i in 0..4
		sum1 += decode1[i]["spritPrice"][0]["amount"].to_f
		end

		sum1 /= 5


		return sum1.to_s;
		#render :text => result

		#render :text => res.body
	end
end
