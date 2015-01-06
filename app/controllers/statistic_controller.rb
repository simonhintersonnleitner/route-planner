class StatisticController < ApplicationController
	require 'net/http'

	def actual
		#save
		#city = ReferenceCities.where(name: "Neunkirchen").take
		#getCheaptestPriceOfCity(city)
	end

	def history
		#save
	end

	def weekday
		#save
	end

	def minMax
				#savePriceforAllCities
	end

	def savePriceforAllCities
		for city in ReferenceCities.all()
    	savePriceOfCity(city)
		end
	end

	def savePriceOfCity(city)
	
		#render :text => decode1
		#render :text => decode1[0]["errorItems"][0]["msgText"]

		responseDiesel = getResponseFromApi(city,"DIE")
		responsePetrol = getResponseFromApi(city,"SUP")

		insert(city,getMinOfResponse(responseDiesel),getMinOfResponse(responsePetrol),getAverageOfResponse(responseDiesel),getAverageOfResponse(responsePetrol))

		#render :text => result
		#render :text => res.body

	end

	def getResponseFromApi(city,type)
		uri = URI('http://www.spritpreisrechner.at/espritmap-app/GasStationServlet')

		lngNorthEast = city.lngNorthEast
		latNorthEast = city.latNorthEast

		lngSouthWest = city.lngSouthWest
		latSouthWest = city.latSouthWest

		respone = Net::HTTP.post_form(uri, "data" => "['','#{type}','#{lngNorthEast}','#{latNorthEast}','#{lngSouthWest}','#{latSouthWest}']")

		return ActiveSupport::JSON.decode(respone.body)

	end

	def getAverageOfResponse(respone)
		sum = 0

		for i in 0..4
			sum += respone[i]["spritPrice"][0]["amount"].to_f
		end

		sum /= 5

		return sum.round(3)
	end

	def getMinOfResponse(respone)
		return respone[0]["spritPrice"][0]["amount"].to_f
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

	def getCityDataById
		if(params[:cityId] == "all")
			prices = PriceData.all()
		else
			prices = PriceData.where(cityFk: params[:cityId])
		end	
		render :json => prices.to_json
	end

	def getCityDataByIdSortedByWeekday

		#calculate average for each weekdays
		if(params[:cityId] == "all")
			prices = PriceData.all()
		else
			prices = PriceData.where(cityFk: params[:cityId])
		end	

		sumDiesel = Array.new(14, 0)
		sumPetrol = Array.new(14, 0)
		
		for price in prices
			d = DateTime.parse(price.updated_at.to_s)
			sumDiesel[d.wday] += price.averageDiesel
			sumDiesel[d.wday+7] += 1
			sumPetrol[d.wday] += price.averagePertrol
			sumPetrol[d.wday+7] += 1
		end

		#create json response object
		pricePerWeekday = Array.new(7,0)

		for i in 0..6
				if sumDiesel[i+7] != 0
					pricePerWeekday[i] = {
    			:weekday => i,
    			:averageDiesel => ((sumDiesel[i])/sumDiesel[i+7]).round(3),
    			:averagePetrol => ((sumPetrol[i])/sumPetrol[i+7]).round(3)}
				else
					pricePerWeekday[i] = {
    			:weekday => i,
    			:averageDiesel => 0,
    			:averagePetrol => 0}
				end
		end
		
  	render :json => pricePerWeekday.to_json  

	end

	def clean
		cities = ReferenceCities.all()
		for city in cities
			priceBefore
			prices = PriceData.where(cityFk: city.id)
			for price in prices
				#if(price.minDiesel == priceBefore.minDiesel)
				#d = DateTime.parse(price.updated_at)
				#priceBefore = price;
			end	
		end
	end

end
