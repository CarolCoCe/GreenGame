extends Node2D

@onready var painel = $Painel

var terraNews = []
var sorteNews = []

# Called when the node enters the scene tree for the first time.
func _ready():
	painel.setTitle("Jornal")
	self.visible = false
	
	var csv_file_path_sorte: String = "res://Data/Jornal/Sorte/Jornal (cartas da terra + sorte) - Copy of cartas da Sorte.csv"
	var csv_file_path_terra: String = "res://Data/Jornal/Terra/Jornal (cartas da terra + sorte) - Copy of cartas da Terra.csv"

	#Sorte
	var file = FileAccess.open(csv_file_path_sorte, FileAccess.READ)
	if file == null:
		print("erro ao abrir o arquivo de jornal sorte")
	else:
		print("consegui abrir o arquivo de jornal sorte")
		var _header = file.get_csv_line()
		while !file.eof_reached():
			var line = file.get_csv_line()
			if len(line) >= 2:
				var storyf = line[0]
				var consequenceCoinsf = int (line[1])
				var cityConsequencef = line[2].split(";")
				var temIncreasef = int(line[3])
				
				var news = Jornal.new(storyf,consequenceCoinsf,temIncreasef, cityConsequencef)
				
				sorteNews.append(news)
	#Terra
	var fileT = FileAccess.open(csv_file_path_terra, FileAccess.READ)
	if fileT == null:
		print("erro ao abrir o arquivo de jornal Terra")
	else:
		print("consegui abrir o arquivo de jornal Terra")
		var _header = fileT.get_csv_line()
		while !fileT.eof_reached():
			var line = fileT.get_csv_line()
			if len(line) >= 2:
				var categorief = line[0]
				var storyf = line[1]
				var consequenceCoinsf = int (line[2])
				var cityConsequencef = line[3].split(";")
				var temIncreasef = int(line[4])
				
				var news = Jornal.new(storyf,consequenceCoinsf,temIncreasef, cityConsequencef, categorief)
				
				terraNews.append(news)
				
func show_jornal():
	#Sorte 
	var randomIndex = randi_range(0, sorteNews.size())
	var randomNew = sorteNews[randomIndex]
	sorteNews.pop_at(randomIndex)
	
	$"Painel/Sorte-Story".text = randomNew.story
	$"Painel/tempIncrease-Sorte".text = str(randomNew.temperatureRise)
	$"Painel/coins-Sorte".text = str(randomNew.coinsConsequence)
	
	#Terra
	var randomIndexT = randi_range(0, terraNews.size())
	var randomNewT = terraNews[randomIndexT]
	terraNews.pop_at(randomIndexT)
	
	$"Painel/Terra-Story".text = randomNewT.story
	$"Painel/tempIncrease-Terra".text = str(randomNewT.temperatureRise)
	$"Painel/coins-Terra".text = str(randomNewT.coinsConsequence)
	
	self.visible = true

func _on_back_button_pressed():
	self.visible = false
