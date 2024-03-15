extends Node2D

@onready var painel = $Painel
@onready var vboxGlobal = $Painel/ScrollContainerGlobal/VBoxContainer
@onready var vboxLocal = $Painel/ScrollContainerLocal/VBoxContainer
@onready var buttonGlobal = $"Painel/Button-global"
@onready var buttonLocal = $"Painel/Button-local"
@onready var buttonMinhas = $"Painel/Button-minhas"

var greenRectScene = load("res://activity/scenes/GreenRect.tscn")

var allActivities = []
var localActivities = []
var playerActivities = []

var playerCurrentCity

# Called when the node enters the scene tree for the first time.
func _ready():
	
	painel.setTitle("Atividades")
	
	var csv_file_path_activities: String = "res://Data/Lista de atividades/Lista de atividades - Copy of ALL (2).csv"

	var file = FileAccess.open(csv_file_path_activities, FileAccess.READ)
	if file == null:
		print("erro ao abrir o arquivo de atividades")
	else:
		print("consegui abrir o arquivo de atividades")
		var _header = file.get_csv_line()
		while !file.eof_reached():
			var line = file.get_csv_line()
			if len(line) >= 2:
				
				var idf = int (line[0])
				var titlef = line[1]
				var timeToReadyf = int(line[2])
				var priceCoinsf = int(line[3])
				var numQuestActivityf = int(line[4])
				var rewardStoryf = line[5]
				var rewardCoinsf = int(line[6])
				var rewardKnowledgeGemsf = int(line[7])
				var temperatureRisef = float(line[8])
				var cityf = line[9]
				
				var activity = Activity.new(idf, titlef,priceCoinsf,numQuestActivityf,rewardCoinsf,rewardKnowledgeGemsf,temperatureRisef,timeToReadyf,rewardStoryf, cityf)
				
				allActivities.append(activity)
				
				if buttonGlobal.button_pressed:
					abaGlobal()

		file.close()
	
func setPlayerCurrentCity (newCity : City):
	playerCurrentCity = newCity

func abaGlobal():
	$Painel/ScrollContainerLocal.visible = false
	$Painel/ScrollContainerGlobal.visible = true
	vboxGlobal.custom_minimum_size = Vector2(10,14500)
	
	#The separation constant in vboxContainer is not working at all
	#For now, I will set the green rectangles position manually :|
	
	var y = 0
	for activity in allActivities:
		var activityRect = createRect(activity,y)
		vboxGlobal.add_child(activityRect)
		y = y + 290 #setting the position


#Como pegar o player? signal com argumento
func abaLocal():
	$Painel/ScrollContainerLocal.visible = true
	$Painel/ScrollContainerGlobal.visible = false
	var activitiesFromCity = playerCurrentCity.getCityActivities()
	
	#Defining the size of the page accordingly to the num of items
	var sizeArray = activitiesFromCity.size()
	var sizePag = sizeArray * 290
	vboxLocal.custom_minimum_size = Vector2(10,sizePag)
	
	var y = 0
	for i in activitiesFromCity:
		var activity = allActivities[int(i) - 1]
		var activityRect = createRect(activity, y)
		activityRect.showButtonPlay()
		vboxLocal.add_child(activityRect)
		y = y + 290

func abaMinhas():
	$Painel/ScrollContainerLocal.visible = false
	$Painel/ScrollContainerGlobal.visible = false
	


func createRect(activity : Activity, y):
	var activityRect = greenRectScene.instantiate()
	var minready = (activity.timeToReady)/60
	
	activityRect.setTitle(activity.title)
	activityRect.setPrice("Custo: " + str(activity.priceCoins))
	activityRect.setTime("Tempo: " + str(minready) + " Min")
	activityRect.setQuestions("Perguntas: " + str(activity.numQuestActivity))
	activityRect.setCity(activity.city)
	activityRect.position = Vector2(0,y) #setting the position
	
	return activityRect



func _on_back_button_pressed():
	self.visible = false
	buttonGlobal.button_pressed = true
	buttonLocal.button_pressed = false
	buttonMinhas.button_pressed = false
	abaGlobal()


func _on_buttonglobal_pressed():
	buttonLocal.button_pressed = false
	buttonMinhas.button_pressed = false
	abaGlobal()
	

func _on_buttonlocal_pressed():
	buttonGlobal.button_pressed = false
	buttonMinhas.button_pressed = false
	abaLocal()


func _on_buttonminhas_pressed():
	buttonLocal.button_pressed = false
	buttonGlobal.button_pressed = false
	abaMinhas()
