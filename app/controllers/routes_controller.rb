class RoutesController < ApplicationController

  def index
    route = Route.find_or_create_by(origin: params[:origin], destination: params[:destination])
    weather = Weather::get_weather(route.path.last)
    hotel_parameters = { term: "hotel", limit: 3 }

    respond_to do |format|
      format.json { 
        render :json => { :route => route.as_json(:except => [:created_at,:updated_at]), :weather => weather, :hotels => Yelp.client.search(params[:destination], hotel_parameters).as_json }
      }
    end
  end

  def get_route_by_id
    user = User.find session[:userID]
    @route = user.routes.find params[:id]
    
    if @route != nil
      render 'index'
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

end
