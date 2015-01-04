# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)




#adding reference Cities to db

referenceCities = ["Bregenz",
	"Innsbruck","Salzburg","Klagenfurt","Graz",
	"Linz","Wien","Eisenstadt","Zirl","Zell am See".] 

for i in referenceCities

	uri2 = 'http://maps.googleapis.com/maps/api/geocode/json?address=' + i

	result = Net::HTTP.get(URI.parse(URI.encode(uri2)))
	puts result
	if(result != nil)
		decode = ActiveSupport::JSON.decode(result)

		latNorthEast = decode["results"][0]["geometry"]["bounds"]["northeast"]["lat"]
		lngNorthEast = decode["results"][0]["geometry"]["bounds"]["northeast"]["lng"]

		latSouthWest = decode["results"][0]["geometry"]["bounds"]["southwest"]["lat"]
		lngSouthWest = decode["results"][0]["geometry"]["bounds"]["southwest"]["lng"]


		cities = ReferenceCities.find_or_initialize_by(name: i)
		cities.name = i
		cities.latNorthEast = latNorthEast
		cities.lngNorthEast = lngNorthEast
		cities.latSouthWest = latSouthWest
		cities.lngSouthWest = lngSouthWest

		cities.save!
	end
end