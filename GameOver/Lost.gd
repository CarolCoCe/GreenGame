extends Node2D
func _ready():
	$AudioStreamPlayer2D.play()
	
func _on_restart_pressed():
	get_tree().change_scene_to_file("res://Menu/Scenes/menu_start.tscn")
