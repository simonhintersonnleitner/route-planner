class RoutesController < ApplicationController

  def get_json
    @route = Route.find_or_create_by(origin: params[:origin], destination: params[:destination])

    respond_to do |format|
      format.json { 

        @route.path = Polylines::Decoder.decode_polyline(@route.path)

        weather = Weather::get_weather(@route.path.last)

        render :json => { :route => @route.as_json(:except => [:created_at,:updated_at]), :weather => weather }
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
