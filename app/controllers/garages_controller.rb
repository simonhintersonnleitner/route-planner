class GaragesController < ApplicationController

  def index

    garages = Garage::get_garages_by_path(params[:path])

    respond_to do |format|
      format.json { 
        render :json => garages.to_json(:except => [:created_at,:updated_at])
      }
    end

  end

  def near
  end

end
