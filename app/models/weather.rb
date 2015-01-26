class Weather

  require 'open-uri'
  require 'json'

  @@url = "https://api.forecast.io/forecast/#{Rails.application.secrets.forecast_api}/"

  def self.get_weather(destination)

    options = {
      :lang => :de,
      :units => :ca,
      :exclude => 'minutely,hourly,daily,alerts,flags'
    }

    result = open(@@url + destination[0].to_s + "," + destination[1].to_s + "?" + options.to_query).read
    json = JSON.parse(result)

    data = Hash.new

    data[:icon] = json["currently"]["icon"].to_s
    data[:temperature] = json["currently"]["temperature"].to_s;

    data.as_json

  end

end
