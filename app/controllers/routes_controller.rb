class RoutesController < ApplicationController

  def getJSON
    @route = Route.new(params[:origin],params[:destination])

    respond_to do |format|
      format.json { render :json => @route.to_json(:except => [:created_at,:updated_at])}
    end

  end

end
