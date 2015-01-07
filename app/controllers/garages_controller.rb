class GaragesController < ApplicationController

  def get_json
    #@garage = Garage.find_or_create_by()
    @garage = Garage.new(lat: params[:lat], lng: params[:lng])

    respond_to do |format|
      format.json { 
        render :json => @garage.to_json(:except => [:created_at,:updated_at])
      }
    end

  end

end
