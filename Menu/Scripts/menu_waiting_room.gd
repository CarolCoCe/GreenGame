extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
		#get_tree().change_scene_to_file("res://main/scene/main.tscn")


func _on_start_pressed():
	get_tree().change_scene_to_file("res://main/scene/main.tscn")
