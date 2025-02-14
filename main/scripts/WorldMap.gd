extends Node2D

class_name WorldMap

var cityWorldMap: Dictionary = {}
var cityButtonScene = preload("res://main/scene/CityButton.tscn")
#var cityArrumar : City


signal cityButtonPressed (city: City)


func add_city( city : City):
	cityWorldMap[city.nameCity] = city
	
	#draw the city points
	var circleCity = cityButtonScene.instantiate()
	add_child(circleCity)
	#this is for adjust the button position
	circleCity.position = city.positionMap - ((circleCity.size * circleCity.scale)/2)
	circleCity.connect("pressed", _on_city_button_pressed.bind(city)) #for the extra argument

	
func _on_city_button_pressed(city):
	cityButtonPressed.emit(city)
	
func add_city_connection (cityA : City, cityB : City):
	if (cityA.connections.find(cityB) == -1):
		cityA.connections.append(cityB)
		cityB.connections.append(cityA)
		
	
func find_city_by_name(cityName: String):
	return cityWorldMap.get(cityName)
		
func calc_distance_flights(origin: City, destiny: City):
	var queue = [origin, 0]  # (city, distance) 
	var visited = []

	while queue.size() > 0:
		var current_city = queue.pop_front() 
		var current_distance = queue.pop_front() 

		if current_city == destiny:
			return current_distance

		visited.append(current_city)

		for connection in current_city.connections:
			if connection not in visited:
				queue.push_back(connection)
				queue.push_back(current_distance + 1) #this count levels, not nodes


	return -1  # No path found

	
func get_random_city():
	var randomKey = cityWorldMap.keys()[randi_range(1,cityWorldMap.size()-1)]
	var randomCityName = cityWorldMap[randomKey]
	return randomCityName
	
