class GaragesController < ApplicationController

  require 'net/http'
  @@url = URI('http://www.spritpreisrechner.at/espritmap-app/GasStationServlet')

  json = nil;

  def get_json
    #@garage = Garage.find_or_create_by()

    types = ["DIE","SUP"]
    garages = []
    

    types.each do |t|

      # Reset, um Dieseltankstellen herauszufiltern
      garages = []

      # API Call
      response = Net::HTTP.post_form(@@url, "data" => "['','#{t}','#{params[:lng]}','#{params[:lat]}','#{params[:lng]}','#{params[:lat]}']")
      json = ActiveSupport::JSON.decode(response.body)

      # Günstigste 5 Tankstellen
      for i in 0..3
        if json[i]["distance"].to_f <= 10
          garage = Garage.find_or_create_by( lat:json[i]["latitude"],lng:json[i]["longitude"] )
          garage.update_data(json[i],t)
          garages.push (garage)
        end
      end

    end

    respond_to do |format|
      format.json { 
        render :json => garages.to_json(:except => [:created_at,:updated_at])
      }
    end

  end

end
