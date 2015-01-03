class RoutesController < ApplicationController

  def get_json
    @route = Route.find_or_create_by(origin: params[:origin], destination: params[:destination])

    respond_to do |format|
      format.json { render :json => @route.to_json(:except => [:created_at,:updated_at])}
    end

  end

end
