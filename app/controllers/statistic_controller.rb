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

		
	end

	def save
		for city in ReferenceCities.all()
    	getCheaptestPriceOfCity(city)
		end
	end

	def getCheaptestPriceOfCity(city)

		uri = URI('http://www.spritpreisrechner.at/espritmap-app/GasStationServlet')

		lngNorthEast = city.lngNorthEast
		latNorthEast = city.latNorthEast

		lngSouthWest = city.lngSouthWest
		latSouthWest = city.latSouthWest

		dieselPrice = Net::HTTP.post_form(uri, "data" => "['','DIE','#{lngNorthEast}','#{latNorthEast}','#{lngSouthWest}','#{latSouthWest}']")
		petrolPrice = Net::HTTP.post_form(uri, "data" => "['','SUP','#{lngNorthEast}','#{latNorthEast}','#{lngSouthWest}','#{latSouthWest}']")

		decode1 = ActiveSupport::JSON.decode(dieselPrice.body)
		decode2 = ActiveSupport::JSON.decode(petrolPrice.body)


		#render :text => decode1
		#render :text => decode1[0]["errorItems"][0]["msgText"]


		if(dieselPrice.kind_of?(Net::HTTPSuccess) && petrolPrice.kind_of?(Net::HTTPSuccess))

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
		prices = PriceData.where(cityFk: params[:cityId])
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
