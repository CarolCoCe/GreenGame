extends Node2D

class_name  City
var nameCity: String
var connections: Array[City] = []
var activities: Array = []
var positionMap: Vector2


func _init(p_nameCity : String, p_activities : Array, p_positionMap: Vector2):
	self.nameCity = p_nameCity
	self.activities = p_activities
	self.positionMap = p_positionMap
	self.connections = []
	
func getCityActivities():
	return activities
