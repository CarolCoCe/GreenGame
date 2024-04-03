extends Node2D

var activityId
@onready var painelverde = $Panel

signal activityPlay (activity)

func setTitle (value):
	$Panel/Title.text = value

func setPrice (value):
	$Panel/PriceCoins.text = value	
	
func setTime (value):
	$Panel/TimeToReady.text = value
	
func setQuestions (value):
	$Panel/Numquestions.text = value
	
func setCity (value):
	$Panel/City.text = value
	
func setActivityId (value):
	activityId = value
	
func showButtonPlay():
	$Panel/ButtonPlay.visible = true
	
func activityUnavailable():
	$Panel/ButtonPlay.visible = false
	var styleboxPainel = StyleBoxFlat.new()
	styleboxPainel.bg_color = Color.html("#3F483C")
	styleboxPainel.corner_radius_bottom_left = 20
	styleboxPainel.corner_radius_bottom_right = 20
	styleboxPainel.corner_radius_top_left = 20
	styleboxPainel.corner_radius_top_right = 20
	#painelverde.add_theme_stylebox_override(styleboxPainel)
	
	
	
func _on_button_play_pressed():
	activityPlay.emit(activityId)
