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
	#Sorte 
	var randomIndex = randi_range(0, sorteNews.size()-1)
	while (sorteNews.size() > 0 and sorteNews[randomIndex] == null):
		randomIndex = randi_range(0, sorteNews.size()-1)
	var randomNew = sorteNews[randomIndex]
	sorteNews.pop_at(randomIndex)
	
	$"Painel/Sorte-Story".text = randomNew.story
	if randomNew.temperatureRise > 0:
		$"Painel/temperature-icon-sorte".visible = true
		$"Painel/tempIncrease-Sorte".text = "+ " + str(randomNew.temperatureRise)
	else:
		$"Painel/temperature-icon-sorte".visible = false
		$"Painel/tempIncrease-Sorte".text = ""

	$"Painel/coins-Sorte".text = str(randomNew.coinsConsequence)
	$"Painel/City-consequence-sorte".text = str(randomNew.cityConsequence)
	
	var strCitySorte = "Isto se aplica para quem está nas seguintes cidades: "
	
	if (randomNew.cityConsequence.size() > 1):
		for i in randomNew.cityConsequence:
			strCitySorte = strCitySorte + str(i) + " ,"
		#this is for taking the last "," out	
		strCitySorte.erase((strCitySorte.length() - 3), 3)
		$"Painel/City-consequence-sorte".text = strCitySorte
	else:
		$"Painel/City-consequence-sorte".text = ""
	
	#Terra
	var randomIndexT = randi_range(0, terraNews.size()-1)
	while (terraNews.size() > 0 and terraNews[randomIndexT] == null):
		randomIndexT = randi_range(0, terraNews.size()-1)
	var randomNewT = terraNews[randomIndexT]
	terraNews.pop_at(randomIndexT)
	
	$"Painel/Terra-Story".text = randomNewT.story
	if randomNewT.temperatureRise > 0:
		$"Painel/temperature-icon-terra".visible = true
		$"Painel/tempIncrease-Terra".text = "+ " + str(randomNewT.temperatureRise)
	else:
		$"Painel/temperature-icon-terra".visible = false
		$"Painel/tempIncrease-Sorte".text = ""
		
	$"Painel/coins-Terra".text = str(randomNewT.coinsConsequence)
	
	var strCity = "Isto se aplica para quem está nas seguintes cidades: "
	
	if (randomNewT.cityConsequence.size() > 1):
		for i in randomNewT.cityConsequence:
			strCity = strCity + str(i) + " ,"
		#this is for taking the last "," out	
		strCity.erase((strCity.length() - 3), 3)
		$"Painel/City-consequence-terra".text = strCity
	else:
		$"Painel/City-consequence-terra".text = ""
	
	self.visible = true

func _on_back_button_pressed():
	self.visible = false
