extends Node2D

@onready var player = $Player
@onready var worldMap = $WorldMap


var csv_file_path_cities: String = "res://Data/Lista de atividades - Mapa.csv"


		
func _ready():
	$"Label-plane".text = str(player._getflights())
	$"Label-coins".text = str(player._getcoins())
	$"Label-kgem".text = str(player._getknowledgeGems())
	var file = FileAccess.open(csv_file_path_cities, FileAccess.READ)
	var fileData = []
	if file == null:
		print("erro ao abrir o arquivo do mapa")
	else:
		print("consegui abrir o arquivo do mapa")
		var _header = file.get_csv_line()
		while !file.eof_reached():
			var line = file.get_csv_line()
			if len(line) >= 2:
				fileData.append(line)
				
				var namef = line[0]
				var activitiesf = line[1].split(";")
				var positionf = Vector2(float(line[3]), float(line[4]))
				
				var cityf = City.new(namef, activitiesf, positionf)
				worldMap.add_city(cityf)
			
		file.close()
		for line in fileData:
			
			var cityAName = line[0]
			var cityA = worldMap.find_city_by_name(cityAName)
			var connectionsf = line[2].split(";")
			for cityBName in connectionsf:
				var cityB = worldMap.find_city_by_name(cityBName)
				worldMap.add_city_connection(cityA,cityB) 
	player._setplayercurrentCity(worldMap.get_random_city())			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func moving_player(cityDestiny : City):
	var distance = worldMap.calc_distance_flights(player.playercurrentCity , cityDestiny)
	var flightsAvailable = player._getflights()
	if (distance <= flightsAvailable):
		player._setflights(flightsAvailable - distance)
		player._setplayercurrentCity(cityDestiny)
		
	
func _on_timer_timeout_rodada():
	
	var valueplane = player._getflights() + 3
	player._setflights(valueplane)
	$"Label-plane".text = str(player._getflights())
	
	var valuecoins = player._getcoins() + 7
	player._setcoins(valuecoins)
	$"Label-coins".text = str(player._getcoins())
	
	$Painel.visible = true
