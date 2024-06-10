extends Node2D
var numtrashsCought = 0
@onready var playerBasket: CharacterBody2D = $playerBasket

signal trashsCought (numTrash)

func _ready():
	update_label()
	playerBasket.connect("_progress_increased", increaseProgress)
	playerBasket.connect("_progress_decreased", decreaseProgress)

func startGame():
	numtrashsCought = 0
	update_label()
	$Timer.start()
	
func increaseProgress():
	$ProgressBar.value += 1 #* delta
	if ($ProgressBar.value >= 100):
		caught_trash()
		
func decreaseProgress():
	$ProgressBar.value -= .6 #* delta
	if ($ProgressBar.value < 0):
		$ProgressBar.value = 0
	
func caught_trash(): 
	numtrashsCought += 1
	update_label()
	$ProgressBar.value = 0
	if (numtrashsCought % 2 == 0):
		$trash/Sprite2D.texture = load("res://MiniGames/FishingTrash/assets/🪥.png")
	elif (numtrashsCought % 3 == 0 or numtrashsCought == 1):
		$trash/Sprite2D.texture = load("res://MiniGames/FishingTrash/assets/🧃.png")
	else:
		$trash/Sprite2D.texture = load("res://MiniGames/FishingTrash/assets/🥤.png")

func update_label():
	$numTrash.text = str(numtrashsCought)
	
func _on_timer_timeout():
	trashsCought.emit(numtrashsCought)
	$trash.free()
	$playerBasket.free()
