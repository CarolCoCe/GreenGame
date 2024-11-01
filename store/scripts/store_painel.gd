extends PainelGeral

@onready var orangeRect = load("res://store/scenes/OrangeRect.tscn")

signal storeBought (coins, flights, orangeRect)


func _ready():
	$Panel/OrangeRect.setSale(7, "coin", 2, "flight")
	$Panel/OrangeRect3.setSale(6, "flight", 4, "coin")
	$Panel/OrangeRect2.setSale(16, "coin", 5, "flight")
	$Panel/OrangeRect4.setSale(4, "flight", 2, "coin")
	
	$Panel/OrangeRect.connect("coinsFlightsStore", storeMain)
	$Panel/OrangeRect3.connect("coinsFlightsStore", storeMain)
	$Panel/OrangeRect2.connect("coinsFlightsStore", storeMain)
	$Panel/OrangeRect4.connect("coinsFlightsStore", storeMain)


func storeMain(coins, flights, orangeRect):
	storeBought.emit(coins, flights, orangeRect)

	
