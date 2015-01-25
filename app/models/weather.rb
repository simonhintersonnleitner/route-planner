class Weather

  require 'open-uri'
  require 'json'

  # TODO: API Key in secrets.yml !!!
  @@url = 'https://api.forecast.io/forecast/a4fbff5dae93def13ba0a022248a9788/'

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
