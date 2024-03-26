class_name PainelGeral extends Panel

func _ready():
	self.visible = false

func setTitle(value):
	$Panel/Title.text = value

func show_alert():
	self.visible = true

func _on_back_button_pressed():
	self.visible = false
