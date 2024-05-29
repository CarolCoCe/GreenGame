extends Node2D

var peer = ENetMultiplayerPeer.new()
@export var player_scene : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_createroom_pressed():
	$Panel.show()
	peer.create_server(1027,5)
	multiplayer.multiplayer_peer =peer
	multiplayer.peer_connected.connect(add_player)
	add_player()

func add_player(id = 1): 
	var player = player_scene.instantiate()
	player.username = str(id)
	call_deferred("add_child",player)

func exit_game(id):
	multiplayer.peer_disconnected.connect(del_player)
	del_player(id)

func del_player (id):
	rpc("_del_player", id)

@rpc("any_peer", "call_local")

func _del_player(id):
	get_node(str(id)).queue_free()
	
func _on_enterroom_pressed():
	$Panel/Title.text = "Entrar em sala privada"
	$Panel/Subtitle.text = "Cole aqui o código da sala que você copiou"
	$Panel.show()
	peer.create_client("127.0.0.1", 1027)
	multiplayer.multiplayer_peer =peer


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Menu/Scenes/menu_waiting_room.tscn")
