extends PainelGeral

@onready var miniGameFishing = $FishingMiniGame
var miniGameEnded = false

signal coinsEarnedFishing (coins)
	
func _ready():
	self.visible = false
	miniGameFishing.connect("trashsCought", fishingEnded)

func _on_back_button_pressed():
	if not miniGameEnded:
		miniGameFishing.show()
		$BackgroundExitButton.hide()
		$Panel.hide()
		miniGameFishing.startGame()
	else:
		self.hide()

func fishingEnded(numTrashCought):
	miniGameEnded = true
	coinsEarnedFishing.emit(numTrashCought)
	$Panel/Title.text = "Mandou Bem!!!"
	miniGameFishing.hide()
	$BackgroundExitButton.show()
	$Panel.show()
	$Panel/Label.text = "É sempre muito relaxante tirar lixo do mar, não é mesmo?
	
Você receberá a recompensa e já poderá continuar com suas atividades!

Você pescou: " + str(numTrashCought) + " lixos, portanto, ganhou : " + str(numTrashCought) + " moedas!!!"
#mandar signal pra main avisando quantas moedas o jogador ganhou
