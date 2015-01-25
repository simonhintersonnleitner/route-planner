class RoutesController < ApplicationController

  def get_json
    @route = Route.find_or_create_by(origin: params[:origin], destination: params[:destination])

    respond_to do |format|
      format.json { 

        @route.path = Polylines::Decoder.decode_polyline(@route.path)

        weather = Weather::get_weather(@route.path.last)

        hotel_parameters = { term: "hotel", limit: 3 }

        render :json => { :route => @route.as_json(:except => [:created_at,:updated_at]), :weather => weather, :hotels => Yelp.client.search(params[:destination], hotel_parameters).as_json }
      }
    end

  end

  def get_route
    @route = Route.find(params[:id])
    if(@route.users.exists?(session[:userID]))
      render 'index'
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

end
