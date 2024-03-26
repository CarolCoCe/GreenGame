extends PainelGeral

var terraNewsGrey = []
var terraNewsRed = []
var terraNewsOrange = []
var terraNewsYellow = []
var usedterraNewsGrey = []
var usedterraNewsRed = []
var usedterraNewsOrange = []
var usedterraNewsYellow = []

var sorteNews = []
var usedSorteNews = []

signal jornalConsequences (newJornal : Jornal)


# Called when the node enters the scene tree for the first time.
func _ready():
	setTitle("Jornal")
	self.visible = false
	
	var csv_file_path_sorte: String = "res://Data/Jornal/Sorte/Jornal (cartas da terra + sorte) - Copy of cartas da Sorte.csv"
	var csv_file_path_terra: String = "res://Data/Jornal/Terra/Jornal (cartas da terra + sorte) - Copy of cartas da Terra.csv"
	
	data_extraction(csv_file_path_sorte, "Sorte")
	data_extraction(csv_file_path_terra, "Terra")

func data_extraction (csv_file_path : String , newsType):
	var file = FileAccess.open(csv_file_path, FileAccess.READ)
	if file == null:
		print("erro ao abrir o arquivo de jornal " + newsType)
	else:
		print("consegui abrir o arquivo de jornal " + newsType)
		var _header = file.get_csv_line()
		while !file.eof_reached():
			var line = file.get_csv_line()
			
			if len(line) >= 2:
				var storyf
				var consequenceCoinsf
				var temIncreasef
				var cityConsequencef
				var news
				
				if newsType == "Terra":
					var categorief = line[0]
					storyf = line[1]
					consequenceCoinsf = int (line[2])

					
					if len(line) < 4: #consequece city is null. Valid for all players then
						temIncreasef = float(line[3])
						news = Jornal.new(storyf,consequenceCoinsf,temIncreasef,[], categorief)
					else:
						cityConsequencef = line[3].split(";")
						temIncreasef = float(line[4])
						news = Jornal.new(storyf,consequenceCoinsf,temIncreasef, cityConsequencef, categorief)
					
					if (categorief == "Cinza"):
						terraNewsGrey.append(news)
					elif(news.categorieTerra == "Vermelho"):
						terraNewsRed.append(news)
					elif(news.categorieTerra == "Laranja"):
						terraNewsOrange.append(news)
					elif(news.categorieTerra == "Amarelo"):
						terraNewsYellow.append(news)
						
				elif newsType == "Sorte":
					storyf = line[0]
					consequenceCoinsf = int (line[1])

					if len(line) < 3: #consequece city is null. Valid for all players then
						temIncreasef = float(line[2])
						news = Jornal.new(storyf,consequenceCoinsf,temIncreasef)
					else:
						cityConsequencef = line[2].split(";")
						temIncreasef = float(line[3])
						news = Jornal.new(storyf,consequenceCoinsf,temIncreasef, cityConsequencef)
										
					sorteNews.append(news)
				
				
func show_jornal(globalTemperature : float):
	showSorte()
	showTerra(globalTemperature)
	self.visible = true

func pickUpRandomNew (deck, usedDeck): # Controls the used deck too
	if (usedDeck.size() >= deck.size()):
		usedDeck = []
		
	var randomIndex = randi_range(0, deck.size()-1)
	while (usedDeck.find(randomIndex) != -1):
		randomIndex = randi_range(0, deck.size()-1)
	var randomNew = deck[randomIndex]
	usedDeck.append(randomIndex)
	
	return randomNew
	
func formatNew (new , type):
	var story
	var iconCoin
	var textCoin
	var iconTemperature 
	var textTemperature
	var cityConsequences
	
	
	if type == "Sorte":
		story = $"Sorte-Story"
		iconCoin = $"TwemojiCoin-sorte"
		textCoin = $"coins-Sorte"
		iconTemperature = $"temperature-icon-sorte"
		textTemperature = $"tempIncrease-Sorte"
		cityConsequences = $"City-consequence-sorte"
	
	elif type == "Terra":
		story = $"Terra-Story"
		iconCoin = $"TwemojiCoin2-terra"
		textCoin = $"coins-Terra"
		iconTemperature = $"temperature-icon-terra"
		textTemperature = $"tempIncrease-Terra"
		cityConsequences = $"City-consequence-terra"
		
	story.text = new.story
	
	if new.temperatureRise > 0:
		iconTemperature.visible = true
		textTemperature.text = "+ " + str(new.temperatureRise)
	else:
		iconTemperature.visible = false
		textTemperature.text = " "
		
		
	if new.coinsConsequence != 0:
		iconCoin.visible = true
		textCoin.text = str(new.coinsConsequence)
	else:
		iconCoin.visible = false
		textCoin.text = " "
		
	var strCity = "Consequências se aplicam para quem está nas seguintes cidades: \n\n"
	
	if (new.cityConsequence[0] != ""):
		for i in new.cityConsequence:
			strCity = strCity + str(i) + ", "
		var leng = strCity.length()
		strCity = strCity.erase(leng-2)
		cityConsequences.text = strCity
	else:
		cityConsequences.text = ""
		
	
func showSorte():
	var randomNewSorte = pickUpRandomNew(sorteNews, usedSorteNews)
	
	jornalConsequences.emit(randomNewSorte)
	formatNew(randomNewSorte, "Sorte")

func showTerra(globalTemperature : float):
	var randomNewTerra 
	var randomIndexTerra

	if (globalTemperature > 0 and globalTemperature <= 1): #categorie : Amarelo / Yellow
		randomNewTerra = pickUpRandomNew(terraNewsYellow, usedterraNewsYellow)

	elif (globalTemperature > 1 and globalTemperature <= 2): #categorie : Laranja / Orange
		randomNewTerra = pickUpRandomNew(terraNewsOrange, usedterraNewsOrange)

	elif (globalTemperature > 2 and globalTemperature <= 3): #categorie :  Vermelho / Red
		randomNewTerra = pickUpRandomNew(terraNewsRed, usedterraNewsRed)
	
	elif (globalTemperature > 3 and globalTemperature <= 4): #categorie : Cinza / Grey
		randomNewTerra = pickUpRandomNew(terraNewsGrey, usedterraNewsGrey)

	jornalConsequences.emit(randomNewTerra)
	formatNew(randomNewTerra, "Terra")
