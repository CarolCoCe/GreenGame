extends Node2D

var username
var activityInProgress
var playercurrentCity 
var coins
var flights
var knowledgeGems
var temperatureInfluence: float


func _getflights():
	return flights
	
func _setflights(value):
	flights = value
	
func _getcoins():
	return coins
	
func _setcoins(value):
	coins = value
	
func _getknowledgeGems():
	return knowledgeGems
	
func _setknowledgeGems(value):
	knowledgeGems = value

func _getplayercurrentCity():
	return playercurrentCity
	
func _setplayercurrentCity(value):
	playercurrentCity = value

# Called when the node enters the scene tree for the first time.
func _ready():
	flights = 3
	coins = 15
	knowledgeGems = 0
	#self.position = playercurrentCity.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
