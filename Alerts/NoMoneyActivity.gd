extends Node2D

@onready var painel = $Painel
# Called when the node enters the scene tree for the first time.
func _ready():
	painel.setTitle("Aviso!")
	self.visible = false
	
func show_alert():
	self.visible = true

func _on_back_button_pressed():
	self.visible = false
