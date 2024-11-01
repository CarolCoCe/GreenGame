extends PainelGeral

@onready var restaurant =$Restaurant
var miniGameEnded = false

signal coinsEarnedRestaurant (coins)
	
func _ready():
	self.visible = false
	restaurant.connect("plate", restaurantEnded)

func _on_back_button_pressed():
	if not miniGameEnded:
		restaurant.show()
		$BackgroundExitButton.hide()
		$Panel.hide()
		restaurant.startTimer()
	else:
		self.hide()

func restaurantEnded(protein, fiber, kgCarbon):
	miniGameEnded = true
	$Panel/Title.text = "Seu prato tem " + str(kgCarbon) + " Kg de CO2."
	restaurant.hide()
	$BackgroundExitButton.show()
	$Panel.show()
	$Panel/TwemojiCoin.show()
	
	var coins = 0
	if protein >= 20 and fiber>= 10:
		coins = int(15/kgCarbon)
		if coins < 1:
			coins = 0
			
	$Panel/coins.text = str(coins)
	$Panel/coins.show()
	$Panel/Label.text = "Para um alimento estar na sua mesa é necessário plantar, extrair água para regá-lo e transportá-lo. 

No caso de animais, ainda ocorre desmatamento para pasto e é necessário produzir as rações, e isso por anos até o abate. Uma árvore absorve 15 Kg de CO2 por ano. 

Você ganha moedas de acordo com a absorção de 1 árvore:"
	coinsEarnedRestaurant.emit(coins)
#mandar signal pra main avisando quantas moedas o jogador ganhou
