extends CharacterBody2D


const SPEED = 30.0

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
	self.position = playercurrentCity.positionMap
	move_and_slide()

# Called when the node enters the scene tree for the first time.
func _ready():
	flights = 3
	coins = 15
	knowledgeGems = 0

func _physics_process(delta):

	#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()
	pass
