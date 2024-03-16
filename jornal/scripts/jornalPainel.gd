extends Node2D

@onready var painel = $Painel

var terraNews = []
var sorteNews = []

signal jornalConsequences (newJornal : Jornal)


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
				
func show_jornal(globalTemperature : float):
	showSorte()
	showTerra(globalTemperature)
	self.visible = true


func _on_back_button_pressed():
	self.visible = false

func showSorte():
	var randomIndexSorte = randi_range(0, sorteNews.size()-1)
	while (sorteNews.size() > 0 and sorteNews[randomIndexSorte] == null):
		randomIndexSorte = randi_range(0, sorteNews.size()-1)
	var randomNewSorte = sorteNews[randomIndexSorte]
	sorteNews.pop_at(randomIndexSorte)
	
	jornalConsequences.emit(randomNewSorte)
	
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
		
		

func showTerra(globalTemperature : float):
	#For eficiency i am picking the range of each categorie in the Jornal Terra csv
	#I dont know if I do it because if I change the csv I will need to change this
	#Efficient x Mannutenability
	
	var rangeMax
	var rangeMin
	
	if (globalTemperature > 0 and globalTemperature <= 1):
		#categorie : Amarelo / Yellow
		rangeMin = 0
		rangeMax = 10
		
	if (globalTemperature > 1 and globalTemperature <= 2):
		#categorie : Laranja / Orange
		rangeMin = 11
		rangeMax = 23
		
	if (globalTemperature > 2 and globalTemperature <= 3):
		#categorie :  Vermelho / Red
		rangeMin = 24
		rangeMax = 39
	
	if (globalTemperature > 3 and globalTemperature <= 4):
		#categorie : Cinza / Grey
		rangeMin = 42
		rangeMax = 50
		
	var randomIndexTerra = randi_range(rangeMin, rangeMax)
	while (terraNews.size() > 0 and terraNews[randomIndexTerra] == null):
		randomIndexTerra = randi_range(rangeMin, rangeMax)
	var randomNewTerra = terraNews[randomIndexTerra]
	terraNews.pop_at(randomIndexTerra)
	
	jornalConsequences.emit(randomNewTerra)
	
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
		
		
