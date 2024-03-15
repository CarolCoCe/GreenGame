extends Node2D

@onready var player = $Player
@onready var worldMap = $WorldMap
@onready var activityPainel = $Activitylists
@onready var jornalPainel = $JornalPainel
@onready var planeAlert = $PlaneAlert

var csv_file_path_cities: String = "res://Data/Mapa/Lista de atividades - Mapa.csv"


		
func _ready():
	$"Label-plane".text = str(player.getflights())
	$"Label-coins".text = str(player.getcoins())
	$"Label-kgem".text = str(player.getknowledgeGems())
	
	worldMap.cityButtonPressed.connect(moving_player)
	
	player.connect("playerChangedCity", activityPainel.setPlayerCurrentCity)
	
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
				
	player.setplayercurrentCity(worldMap.get_random_city())			

func moving_player(cityDestiny : City):
	var distance = worldMap.calc_distance_flights(player.playercurrentCity , cityDestiny)
	var flightsAvailable = player.getflights()
	if (flightsAvailable >= distance and distance > -1):
		player.setflights(flightsAvailable - distance)
		$"Label-plane".text = str(player.getflights())
		player.setplayercurrentCity(cityDestiny)
	else:
		planeAlert.show_alert()
		
	
func _on_timer_timeout_rodada():
	
	var flightsAvailable =  player.getflights() + 3
	player.setflights(flightsAvailable)
	$"Label-plane".text = str(player.getflights())
	
	var valuecoins = player.getcoins() + 7
	player.setcoins(valuecoins)
	$"Label-coins".text = str(player.getcoins())
	
	jornalPainel.show_jornal()



func _on_activity_list_button_pressed():
	activityPainel.visible = true
	
