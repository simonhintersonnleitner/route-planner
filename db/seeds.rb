# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)




#adding reference Cities to db

reference_cities = [
	"Bregenz",
	"Innsbruck","Salzburg","Klagenfurt","Graz",
	"Linz","Wien","Eisenstadt","Zirl","Zell am See",
	"Villach",
	"Wels",
	"St. Pölten",	
	"Dornbirn",	
	"Wiener Neustadt",	
	"Steyr",
	"Feldkirch",	
	"Leonding",
	"Klosterneuburg",	
	"Wolfsberg",	
	"Leoben",	
	"Krems an der Donau",
	"Amstetten", 	
	"Lustenau",	
	"Kapfenberg",	
	"Mödling",	
	"Hallein",	
	"Kufstein",	
	"Traiskirchen",	
	"Schwechat",	
	"Braunau am Inn",	
	"Stockerau",	
	"Saalfelden am Steinernen Meer",	
	"Ansfelden",	
	"Tulln an der Donau",	
	"Hohenems",
	"Spittal an der Drau",	
	"Telfs",
	"Ternitz",	
	"Perchtoldsdorf",	
	"Feldkirchen in Kärnten",	
	"Bludenz",	
	"Bad Ischl",
	"Schwaz",
	"Hall in Tirol",	
	"Gmunden",	
	"Wörgl",	
	"Wals-Siezenheim",	
	"Marchtrenk",	
	"Bruck an der Mur",	
	"St. Veit an der Glan",	
	"Korneuburg",	
	"Vöcklabruck",	
	"Lienz",	
	"Rankweil",	
	"Hollabrunn",
	"Enns",
	"Brunn am Gebirge",	
	"Ried im Innkreis",
	"Bad Vöslau",	
	"Waidhofen an der Ybbs",	
	"Knittelfeld",	
	"Trofaiach",
	"Mistelbach",	
	"Zwettl",
	"Völkermarkt",	
	"Götzis",
	"Sankt Johann im Pongau",	
	"Gänserndorf",	
	"Bischofshofen",	
	"Gerasdorf bei Wien",
	"Ebreichsdorf",
	"Seekirchen am Wallersee",	
	"St. Andrä",	
	"Groß-Enzersdorf"] 

for i in reference_cities

	uri2 = 'http://maps.googleapis.com/maps/api/geocode/json?language=de&address=' + i

	sleep(1)
	result = Net::HTTP.get(URI.parse(URI.encode(uri2)))
	puts result
	if(result != nil)
		decode = ActiveSupport::JSON.decode(result)

		latNorthEast = decode["results"][0]["geometry"]["viewport"]["northeast"]["lat"]
		lngNorthEast = decode["results"][0]["geometry"]["viewport"]["northeast"]["lng"]

		latSouthWest = decode["results"][0]["geometry"]["viewport"]["southwest"]["lat"]
		lngSouthWest = decode["results"][0]["geometry"]["viewport"]["southwest"]["lng"]

		latLocation = decode["results"][0]["geometry"]["location"]["lat"]
		lngLocation = decode["results"][0]["geometry"]["location"]["lng"]


		cities = ReferenceCities.find_or_initialize_by(name: i)
		cities.name = i
		cities.lat_north_east = latNorthEast
		cities.lng_north_east = lngNorthEast
		cities.lat_south_west = latSouthWest
		cities.lng_south_west = lngSouthWest
		cities.lat_location = latLocation
		cities.lng_location = lngLocation
		cities.region = decode["results"][0]["address_components"][decode["results"][0]["address_components"].length-3]["short_name"]
		cities.state = decode["results"][0]["address_components"][decode["results"][0]["address_components"].length-2]["short_name"]

		cities.save!
	end
end