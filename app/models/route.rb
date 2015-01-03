class Route < ActiveRecord::Base

  def initialize(o,d)
    @origin = o
    @destination = d

    # TODO:
    # get data

  end

  def getData
    # set time
    # set distance
    # set path (Polylines::Decoder.decode_polyline(@path))
  end

end
