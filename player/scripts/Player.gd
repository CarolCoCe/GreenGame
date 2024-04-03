extends CharacterBody2D

class_name Player
const SPEED = 30.0

var username
var activitiesPlayer = []
var playercurrentCity 
var coins
var flights
var knowledgeGems
var temperatureInfluence: float

signal playerChangedCity (currentCityPlayer: City)

func getflights():
	return flights
	
func setflights(value):
	flights = value
	
func getcoins():
	return coins
	
func setcoins(value):
	coins = value
	
func getknowledgeGems():
	return knowledgeGems
	
func setknowledgeGems(value):
	knowledgeGems = value

func getplayercurrentCity():
	return playercurrentCity
	
func setplayercurrentCity(value):
	if self.playercurrentCity != null:
		#move_toward(playercurrentCity.positionMap,value.positionMap,100)
		move_and_slide()
	playercurrentCity = value
	self.position = playercurrentCity.positionMap
	playerChangedCity.emit(playercurrentCity)

# Called when the node enters the scene tree for the first time.
func _ready():
	flights = 3
	coins = 120
	knowledgeGems = 0


