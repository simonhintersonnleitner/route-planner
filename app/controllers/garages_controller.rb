class GaragesController < ApplicationController

  def get_json_by_path

    garages = Garage::get_garages_by_path(params[:path])

    respond_to do |format|
      format.json { 
        render :json => garages.to_json(:except => [:created_at,:updated_at])
        #render :json => garages.to_json
      }
    end

  end

  def near
  end

end
