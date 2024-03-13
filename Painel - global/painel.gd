extends Panel

func setTitle(value):
	$Panel/Title.text = value

func setContentFull(value):
	$Panel/ContentFull.text = value
# Called when the node enters the scene tree for the first time.

func setTextureButtonBack(valueNormal, valuePressed):
	$Panel/TextureButtonBack.texture_normal = valueNormal
	$Panel/TextureButtonBack.texture_pressed = valuePressed
	
	
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_texture_button_pressed():
	$".".visible = false
