extends Node2D

signal coinsFlightsStore (coins, flights, orangeRect)

var coins
var flights

func setSale(price, typePrice, product, typeProduct):
	$Panel/price.text = str(price)
	$Panel/product.text = str(product)
	if typePrice == "coin":
		$"Panel/✈️price".hide()
		coins = price * (-1) #player decrease coins
	else:
		$"Panel/price coin".hide()
		flights = price * (-1)
		
	if typeProduct == "coin":
		$"Panel/✈product".hide()
		coins = product
	else:
		$"Panel/product coin".hide()
		flights = product


func _on_button_pressed():
	coinsFlightsStore.emit(coins,flights,self)
	
	
