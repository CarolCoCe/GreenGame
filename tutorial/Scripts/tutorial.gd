extends Node2D
var pageTutorial = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_skiptutorial_pressed():
	get_tree().change_scene_to_file("res://Menu/Scenes/menu_start.tscn")


func _on_next_pressed():
	pageTutorial = pageTutorial + 1
	var newText = "Tutorial:"
	if pageTutorial == 2:
		newText = "bla bla bla 2"
	if pageTutorial == 3:
		newText = "3vdvf"
	if pageTutorial == 4:
		$Next.hide()
	
	
	$Label.text = newText
