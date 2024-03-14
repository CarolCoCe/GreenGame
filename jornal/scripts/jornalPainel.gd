extends Node2D

@onready var painel = $Painel
# Called when the node enters the scene tree for the first time.
func _ready():
	painel.setTitle("Jornal")
	self.visible = false

func show_jornal():
	self.visible = true

func _on_back_button_pressed():
	self.visible = false
