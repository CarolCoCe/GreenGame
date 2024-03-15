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
				var temIncreasef
				var cityConsequencef
				var news
				
				if len(line) < 3: #consequece city is null. Valid for all players then
					temIncreasef = float(line[2])
					news = Jornal.new(storyf,consequenceCoinsf,temIncreasef)
				else:
					cityConsequencef = line[2].split(";")
					temIncreasef = float(line[3])
					news = Jornal.new(storyf,consequenceCoinsf,temIncreasef, cityConsequencef)
				
				
				sorteNews.append(news)
	#Terra
	var fileT = FileAccess.open(csv_file_path_terra, FileAccess.READ)
	if fileT == null:
		print("erro ao abrir o arquivo de jornal Terra")
	else:
		print("consegui abrir o arquivo de jornal Terra")
		var _header = fileT.get_csv_line()
		while !fileT.eof_reached():
			var lineT = fileT.get_csv_line()
			if len(lineT) >= 2:
				var categorief = lineT[0]
				var storyf = lineT[1]
				var consequenceCoinsf = int (lineT[2])
				var temIncreasef
				var cityConsequencef
				var news
				
				if len(lineT) < 4: #consequece city is null. Valid for all players then
					temIncreasef = float(lineT[3])
					news = Jornal.new(storyf,consequenceCoinsf,temIncreasef,[], categorief)
				else:
					cityConsequencef = lineT[3].split(";")
					temIncreasef = float(lineT[4])
					news = Jornal.new(storyf,consequenceCoinsf,temIncreasef, cityConsequencef, categorief)
				
				terraNews.append(news)
				
func show_jornal():
	showSorte()
	showTerra()
	self.visible = true


func _on_back_button_pressed():
	self.visible = false

func showSorte():
	var randomIndexSorte = randi_range(0, sorteNews.size()-1)
	while (sorteNews.size() > 0 and sorteNews[randomIndexSorte] == null):
		randomIndexSorte = randi_range(0, sorteNews.size()-1)
	var randomNewSorte = sorteNews[randomIndexSorte]
	sorteNews.pop_at(randomIndexSorte)
	
	$"Painel/Sorte-Story".text = randomNewSorte.story
	
	if randomNewSorte.temperatureRise > 0:
		$"Painel/temperature-icon-sorte".visible = true
		$"Painel/tempIncrease-Sorte".text = "+ " + str(randomNewSorte.temperatureRise)
	else:
		$"Painel/temperature-icon-sorte".visible = false
		$"Painel/tempIncrease-Sorte".text = " "
		
		
	if randomNewSorte.coinsConsequence != 0:
		$"Painel/TwemojiCoin-sorte".visible = true
		$"Painel/coins-Sorte".text = str(randomNewSorte.coinsConsequence)
	else:
		$"Painel/TwemojiCoin-sorte".visible = false
		$"Painel/coins-Sorte".text = " "
		
	var strCity = "Consequências se aplicam para quem está nas seguintes cidades: \n\n"
	
	if (randomNewSorte.cityConsequence[0] != ""):
		for i in randomNewSorte.cityConsequence:
			strCity = strCity + str(i) + ", "
		var leng = strCity.length()
		strCity = strCity.erase(leng-2)
		$"Painel/City-consequence-sorte".text = strCity
	else:
		$"Painel/City-consequence-sorte".text = ""
		
		

func showTerra():
	var randomIndexTerra = randi_range(0, terraNews.size()-1)
	while (terraNews.size() > 0 and terraNews[randomIndexTerra] == null):
		randomIndexTerra = randi_range(0, terraNews.size()-1)
	var randomNewTerra = terraNews[randomIndexTerra]
	terraNews.pop_at(randomIndexTerra)
	
	$"Painel/Terra-Story".text = randomNewTerra.story
	
	if randomNewTerra.temperatureRise > 0:
		$"Painel/temperature-icon-terra".visible = true
		$"Painel/tempIncrease-Terra".text = "+ " + str(randomNewTerra.temperatureRise)
	else:
		$"Painel/temperature-icon-terra".visible = false
		$"Painel/tempIncrease-Terra".text = " "
		
		
	if randomNewTerra.coinsConsequence != 0:
		$"Painel/TwemojiCoin2-terra".visible = true
		$"Painel/coins-Terra".text = str(randomNewTerra.coinsConsequence)
	else:
		$"Painel/TwemojiCoin2-terra".visible = false
		$"Painel/coins-Terra".text = " "
		
	var strCity = "Consequências se aplicam para quem está nas seguintes cidades: \n\n"
	
	if (randomNewTerra.cityConsequence[0] != ""):
		for i in randomNewTerra.cityConsequence:
			strCity = strCity + str(i) + ", "
		var leng = strCity.length()
		strCity = strCity.erase(leng-2)
		$"Painel/City-consequence-terra".text = strCity
	else:
		$"Painel/City-consequence-terra".text = ""
		
		
