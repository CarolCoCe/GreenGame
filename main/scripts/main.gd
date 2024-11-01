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
@onready var rewardActivity = $painel_activity_reward
@onready var kgemPainel = $"Painel-kgem"
@onready var menuWaitingRoom = $menu_waiting_room
@onready var miniGameFishing = $Minigame_fishing_tutorial
@onready var alertNoKGem = $Alert_no_k_gem
@onready var storePainel = $"Store-painel"
@onready var miniGameRestaurant = $minigame_restaurant_tutorial

@onready var backgroundGrey = load("res://assets/backgrounds/Imagem real - cinza.png")
@onready var backgroundRed = load("res://assets/backgrounds/Imagem real - vermelho.png")
@onready var backgroundOrange = load("res://assets/backgrounds/Imagem real - laranja.png")
@onready var backgroundYellow = load("res://assets/backgrounds/Imagem real - amarelo.png")


var csv_file_path_cities: String = "res://Data/Mapa/Lista de atividades - Mapa.csv"

var globalTemperature : float = 1.25
var communityKnowledgeGems : int
var KGemTemperaturePower = -0.25
var KGemPrice = 8

func getGlobalTemperature():
	return globalTemperature

func addGlobalTemperature(value : float):
	globalTemperature = globalTemperature + value
	if value > 0:
		$"Temp increase - AudioStreamPlayer2D".play()
	$Termometro.value = globalTemperature
	if (globalTemperature < 1):
		$JogoGsd.texture = backgroundYellow
	elif (globalTemperature < 2):
		$JogoGsd.texture = backgroundOrange
	elif (globalTemperature < 3):
		$JogoGsd.texture = backgroundRed
	elif (globalTemperature < 4):
		$JogoGsd.texture = backgroundGrey
	if (globalTemperature > 4):
		get_tree().change_scene_to_file.bind("res://GameOver/Lost.tscn").call_deferred()
	elif (globalTemperature <= 0):
		get_tree().change_scene_to_file.bind("res://GameOver/Won.tscn").call_deferred()
	
func getCommunityKnowledgeGems():
	return communityKnowledgeGems

func addCommunityKnowledgeGems(value):
	communityKnowledgeGems = communityKnowledgeGems + value
	
func changePlayerSkin(playerSkinString):
	player.setPlayerSkin(playerSkinString)
	$"Timer-rodada".start()
	$"Timer-miniGame-Fishing".start()
	$"Timer-Restaurant-minigame".start()
	menuWaitingRoom.hide()
		
func _ready():
	$menu_waiting_room.show()
	
	
	$"Label-plane".text = str(player.getflights())
	$"Label-coins".text = str(player.getcoins())
	$"Label-kgem".text = str(player.getknowledgeGems())
	
	worldMap.cityButtonPressed.connect(moving_player)	
	activityPainel.connect("activityPlayObject",dealPlayActivity)	
	player.connect("playerChangedCity", activityPainel.getPlayer)	
	player.connect("activityFinishedPlayer", dealActivityFinished)
	jornalPainel.connect("jornalConsequences", dealJornalConsequences)
	kgemPainel.connect("kgemDonated", dealKgemDonated)
	kgemPainel.connect("kgemSold", dealKgemSold)
	menuWaitingRoom.connect("playerChoseSkin", changePlayerSkin)
	miniGameFishing.connect("coinsEarnedFishing", fishingMiniGameEnded)
	storePainel.connect("storeBought", dealStore)
	miniGameRestaurant.connect("coinsEarnedRestaurant", restaurantMiniGameEnded)

	
	
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
		$"Wrong question- AudioStreamPlayer2D".play()
		
	
func _on_timer_timeout_rodada():
	player.addflights(2)
	$"Label-plane".text = str(player.getflights())
	
	player.addcoins(5)
	$"Label-coins".text = str(player.getcoins()) 
	
	jornalPainel.show_jornal(globalTemperature)

func dealJornalConsequences (jornal : Jornal):
	var increaseTemp = jornal.temperatureRise
	addGlobalTemperature(increaseTemp)
	
	if jornal.cityConsequence[0] == "":
		player.addcoins(jornal.coinsConsequence)
	else:
		for city in jornal.cityConsequence:
			if player.playercurrentCity.nameCity == city:
				player.addcoins(jornal.coinsConsequence)
	$"Label-coins".text = str(player.getcoins())
	
func dealActivityFinished(activity: Activity):
	$"Activity Reward - AudioStreamPlayer2D".play()
	rewardActivity.show_reward(activity)
	player.addcoins(activity.rewardCoins)
	addGlobalTemperature(activity.temperatureRise)
	player.addknowledgeGems(activity.rewardKnowledgeGems)
	$"Label-coins".text = str(player.getcoins())
	$"Label-kgem".text = str(player.getknowledgeGems())
	
func dealPlayActivity(activity : Activity):
	if player.coins >= activity.priceCoins:
		if activity.available:
			activity.available = false
			player.addcoins(- activity.priceCoins)
			$"Label-coins".text = str(player.getcoins())
			var result = await quizQuestions.startQuiz(activity.numQuestActivity)
			
			quizQuestions.visible = false #trocar isso aqui na hora de colocar os ads ?
			if result == -1: #wrong
				$"Wrong question- AudioStreamPlayer2D".play()
				quizWrongQuestion.show_alert()
				activity.available = true
				
			elif result == 1: #quiz ok
				$"Activity started- AudioStreamPlayer2D".play()
				activityStarted.show_alert()
				player.addActivityPlayer(activity)
				
		
	else:
		NoMoneyActivityAlert.show_alert()
		$"Wrong question- AudioStreamPlayer2D".play()

func dealKgemDonated():
	if player.getknowledgeGems() > 0:
		addGlobalTemperature(KGemTemperaturePower)
		player.addknowledgeGems(-1)
		$"Label-kgem".text = str(player.getknowledgeGems())
	else:
		alertNoKGem.show()
		
func dealKgemSold():
	if player.getknowledgeGems() > 0:
		player.addknowledgeGems(-1)
		$"Label-kgem".text = str(player.getknowledgeGems())
		player.addcoins(KGemPrice)
		$"Label-coins".text = str(player.getcoins())
	else:
		alertNoKGem.show()

func dealStore(coins, flights, orangeRect):
	if coins < 0: 
		if player.coins >= abs(coins):
			player.addcoins(coins)
			$"Label-coins".text = str(player.getcoins())
			player.addflights(flights)
			$"Label-plane".text = str(player.getflights())
		else:
			NoMoneyActivityAlert.show_alert()
			$"Wrong question- AudioStreamPlayer2D".play()
	elif flights < 0:
		if player.flights >= abs(flights):
			player.addflights(flights)
			$"Label-plane".text = str(player.getflights())
			player.addcoins(coins)
			$"Label-coins".text = str(player.getcoins())
		else:
			planeAlert.show_alert()
			$"Wrong question- AudioStreamPlayer2D".play()
	
func _on_activity_list_button_pressed():
	activityPainel.show()
	activityPainel._on_buttonlocal_pressed()

func _on_buttonminitutorial_pressed():
	$"Mini-tutorial".show()


func _on_termometro_value_changed(value):
	$"Label -temp".text = str(value) + " ºC"


func _on_button_k_gem_pressed():
	kgemPainel.show()


func _on_timermini_game_fishing_timeout():
	$"Timer-rodada".paused = true
	miniGameFishing.show()
	

func _on_buttonstore_pressed():
	storePainel.show()

func fishingMiniGameEnded(coinsGained):
	$"Activity Reward - AudioStreamPlayer2D".play()
	player.addcoins(coinsGained)
	$"Label-coins".text = str(player.getcoins())
	$"Timer-rodada".paused = false
	
	$"Timer-miniGame-Fishing".free()
	$menu_waiting_room.free()
	
func _on_timer_restaurantminigame_timeout():
	$"Timer-rodada".paused = true
	$minigame_restaurant_tutorial.show()
	
func restaurantMiniGameEnded(coinsGained):
	$"Activity Reward - AudioStreamPlayer2D".play()
	player.addcoins(coinsGained)
	$"Label-coins".text = str(player.getcoins())
	$"Timer-rodada".paused = false
	
	$Minigame_fishing_tutorial.free()
	$"Timer-Restaurant-minigame".free()
	
