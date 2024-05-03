extends Node2D

@onready var player = $Player
@onready var worldMap = $WorldMap
@onready var activityPainel = $painel_activity
@onready var jornalPainel = $painel_jornal
@onready var planeAlert = $painel_plane_alert
@onready var NoMoneyActivityAlert = $Painel_no_money_to_activity
@onready var quizQuestions = $painel_questions
@onready var quizWrongQuestion = $painel_wrong_question
@onready var activityStarted = $painel_activity_started


var csv_file_path_cities: String = "res://Data/Mapa/Lista de atividades - Mapa.csv"

var globalTemperature : float = 1.25
var communityKnowledgeGems : int

func getGlobalTemperature():
	return globalTemperature

func addGlobalTemperature(value : float):
	globalTemperature = globalTemperature + value
	$Termometro.value = globalTemperature
	if (globalTemperature > 4):
		get_tree().change_scene_to_file.bind("res://GameOver/Lost.tscn").call_deferred()
	
func getcommunityKnowledgeGems():
	return communityKnowledgeGems

func setcommunityKnowledgeGems(value):
	communityKnowledgeGems = value
		
func _ready():
	$"Label-plane".text = str(player.getflights())
	$"Label-coins".text = str(player.getcoins())
	$"Label-kgem".text = str(player.getknowledgeGems())
	
	worldMap.cityButtonPressed.connect(moving_player)	
	activityPainel.connect("activityPlayObject",dealPlayActivity)	
	player.connect("playerChangedCity", activityPainel.setPlayerCurrentCity)	
	jornalPainel.connect("jornalConsequences", dealJornalConsequences)
	
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
	
	var flightsAvailable =  player.getflights() + 2
	player.setflights(flightsAvailable)
	$"Label-plane".text = str(player.getflights())
	
	var valuecoins = player.getcoins() + 5
	player.setcoins(valuecoins)
	$"Label-coins".text = str(player.getcoins())
	
	jornalPainel.show_jornal(globalTemperature)

func dealJornalConsequences (jornal : Jornal):
	var increaseTemp = jornal.temperatureRise
	addGlobalTemperature(increaseTemp)
	
	if jornal.cityConsequence[0] == "":
		var coins = player.getcoins()
		coins = coins + jornal.coinsConsequence
		player.setcoins(coins)
	else:
		for city in jornal.cityConsequence:
			if player.playercurrentCity.nameCity == city:
				var coins = player.getcoins()
				coins = coins + jornal.coinsConsequence
				player.setcoins(coins)
	$"Label-coins".text = str(player.getcoins())
	
func dealPlayActivity(activity : Activity):
	if player.coins >= activity.priceCoins:
		if activity.available:
			activity.available = false
			var newValue = player.getcoins() - activity.priceCoins
			player.setcoins(newValue)
			$"Label-coins".text = str(player.getcoins())
			var result = await quizQuestions.startQuiz(activity.numQuestActivity)
			
			quizQuestions.visible = false #trocar isso aqui na hora de colocar os ads ?
			if result == -1: #wrong
				quizWrongQuestion.show_alert()
				activity.available = true
				
			elif result == 1: #quiz ok
				activityStarted.show_alert()
				player.addActivityPlayer(activity)
				
				#colocar a atividade como unavailable ok
				#colocar a atividade em minhas do player ok
				#soltar o timer da recompensa
				#a Minhas atividades puxa de player
		
	else:
		NoMoneyActivityAlert.show_alert()

func _on_activity_list_button_pressed():
	activityPainel.visible = true
	activityPainel._on_buttonlocal_pressed()
	


func _on_buttonminitutorial_pressed():
	$"Mini-tutorial".visible = true


func _on_termometro_value_changed(value):
	$"Label -temp".text = str(value) + " ºC"
