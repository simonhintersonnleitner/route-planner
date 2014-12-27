class WelcomeController < ApplicationController
require 'net/http'
require 'json'

	def index 
		#47.2718, 11.2517
	  	uri = URI('http://www.spritpreisrechner.at/espritmap-app/GasStationServlet')
		res = Net::HTTP.post_form(uri, "data" => "['','DIE','11.2517','47.2718','11.2517','47.2718']")
		res2 = Net::HTTP.post_form(uri, "data" => "['Wien','DIE',]")
		decode = ActiveSupport::JSON.decode(res.body)
		 
		sum = 0

		for i in 0..4
			sum += decode[i]["spritPrice"][0]["amount"].to_f
		end

		sum /= 5

		#render :text => sum
		render :text => res2.body
	end
end
