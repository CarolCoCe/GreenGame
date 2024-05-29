extends PainelGeral

signal kgemDonated
signal kgemSold

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_buttondonate_pressed():
	kgemDonated.emit()


func _on_buttonsell_pressed():
	kgemSold.emit()
