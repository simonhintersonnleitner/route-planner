class StatisticController < ApplicationController
	require 'net/http'
  
	def actual
	
	end

	def history
		
	end

	def weekday
	  # enable caching
    expires_in 1.day, :public => true
	end

	def reference

	end

	def minMax
			
	end

  def averange
      
  end

	def save
		render :text => PriceData.save_price_for_all_cities
	end

	def clean
		render :text => PriceData.clean
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
      # save amount of values per day
      sum_diesel[d.wday+7] += 1
      sum_super[d.wday] += price.average_super
      # save amount of values per day
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
