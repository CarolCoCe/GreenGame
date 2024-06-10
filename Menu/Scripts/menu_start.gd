extends Node2D



func _on_play_pressed():
	get_tree().change_scene_to_file("res://main/scene/main.tscn")


func _on_tutorial_pressed():
	get_tree().change_scene_to_file("res://tutorial/Scenes/tutorial.tscn")
