extends Node

class_name Jornal

var story : String
var coinsConsequence : int
var temperatureRise : float
var cityConsequence = []
var categorieTerra : String


func _init(
		p_story : String,
		p_coinsConsequence : int,
		p_temperatureRise : float,
		p_cityConsequence : Array = [],
		p_categorieTerra : String = "null"
		):
			self.story = p_story
			self.coinsConsequence = p_coinsConsequence
			self.temperatureRise = p_temperatureRise
			self.cityConsequence = p_cityConsequence
			self.categorieTerra = p_categorieTerra
