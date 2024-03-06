extends Node2D

class_name WorldMap
# Called when the node enters the scene tree for the first time.

var cityWorldMap: Dictionary = {}


func add_city( city : City):
	cityWorldMap[city.nameCity] = city
	
	#draw the city points
	var circleCity = TextureButton.new()
	var texture = load("res://assets/white-button_0001.png")
	var textureHover = load("res://assets/white-button_0002.png")
	var texturePressed = load("res://assets/white-button_0003.png")
	
	circleCity.scale = Vector2(0.028,0.028)
	circleCity.size = (circleCity.scale * Vector2(512,512)) 
	# 512 is the size of the texture image!
	circleCity.texture_normal = texture
	circleCity.texture_hover = textureHover
	circleCity.texture_pressed = texturePressed
	circleCity.position = city.positionMap - circleCity.size/2
	circleCity.visible = true
	circleCity.z_index = 1
	circleCity.STRETCH_KEEP_CENTERED
	#circleCity.connect("pressed", moving_player) #Como eu chamo essa func que tá na main???
	
	add_child(circleCity)

	
func add_city_connection (cityA : City, cityB : City):
	if (cityA.connections.find(cityB) == -1):
		cityA.connections.append(cityB)
		cityB.connections.append(cityA)
		
		#draw the lines, unless is LA-Tokyo
		if !((cityA.nameCity == "Los Angeles" and cityB.nameCity == "Tóquio") or (cityB.nameCity == "Los Angeles" and cityA.nameCity == "Tóquio")):
			var lineFlights = Line2D.new()
			lineFlights.points = [cityA.positionMap, cityB.positionMap]
			lineFlights.width = 2
			add_child(lineFlights)

		else:
			var lineFlights1 = Line2D.new()
			var lineFlights2 = Line2D.new()
			lineFlights1.points = [cityA.positionMap, Vector2(0,cityB.positionMap.y)]
			lineFlights2.points = [cityB.positionMap, Vector2(1153,cityA.positionMap.y)]
			lineFlights1.width = 2
			lineFlights2.width = 2
			add_child(lineFlights1)
			add_child(lineFlights2)
	
func find_city_by_name(cityName: String):
	return cityWorldMap.get(cityName)
		
func calc_distance_flights(origin: City, destiny: City):
	var visited_cities = []
	var queue = [origin]
	var distance = 0

	while queue.size() > 0:
		var current_city = queue.pop_front()

		if current_city == destiny:
			return distance

		visited_cities.append(current_city)

		for connection in current_city.connections:
			if connection not in visited_cities and connection not in queue:
				queue.push_back(connection)

		distance += 1

	return -1  # No path found
	
func get_random_city():
	var randomKey = cityWorldMap.keys()[randi_range(1,cityWorldMap.size()-1)]
	var randomCityName = cityWorldMap[randomKey]
	return randomCityName
	
#func on_circleCity_pressed():
	#return self

