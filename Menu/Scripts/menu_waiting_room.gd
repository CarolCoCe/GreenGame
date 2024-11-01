extends Node2D
var playerSkin = "res://assets/playerSkins/skin1.png"

var emoji_options = {
	"PainelGeral/GridContainer/Button": "res://assets/playerSkins/skin1.png",
	"PainelGeral/GridContainer/Button2": "res://assets/playerSkins/skin2.png",
	"PainelGeral/GridContainer/Button3": "res://assets/playerSkins/skin3.png",
	"PainelGeral/GridContainer/Button4": "res://assets/playerSkins/skin4.png",
	"PainelGeral/GridContainer/Button5": "res://assets/playerSkins/skin5.png",
	"PainelGeral/GridContainer/Button6": "res://assets/playerSkins/skin6.png",
	"PainelGeral/GridContainer/Button7": "res://assets/playerSkins/skin7.png",
	"PainelGeral/GridContainer/Button8": "res://assets/playerSkins/skin8.png",
	"PainelGeral/GridContainer/Button9": "res://assets/playerSkins/skin9.png",
	"PainelGeral/GridContainer/Button10": "res://assets/playerSkins/skin10.png"

}

signal playerChoseSkin (playerSkin)

func _ready():
	for buttonString in emoji_options.keys():
		var buttonEmoji = get_node(buttonString)
		buttonEmoji.connect("pressed", _on_button_pressed.bind(buttonString))

func _on_start_pressed():
	playerChoseSkin.emit(playerSkin)

func _on_choose_emoji_pressed():
	$PainelGeral.show()

func _on_button_pressed(button_name):
	if button_name in emoji_options: 
		playerSkin = emoji_options[button_name]
		$"Choose emoji".icon = load(playerSkin)
