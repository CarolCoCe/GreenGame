extends PainelGeral

@onready var vboxGlobal = $ScrollContainerGlobal/VBoxContainer
@onready var vboxLocal = $ScrollContainerLocal/VBoxContainer
@onready var vboxMinhas = $ScrollContainerMinhas/VBoxContainer
@onready var buttonGlobal = $"Button-global"
@onready var buttonLocal = $"Button-local"
@onready var buttonMinhas = $"Button-minhas"

var greenRectScene = load("res://activity/scenes/GreenRect.tscn")

var allActivities = []
var localActivities = []
var playerActivities = []

var currentPlayer

signal activityPlayObject (activityId)

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	setTitle("Atividades")
	var csv_file_path_activities: String = "res://Data/Lista de atividades/Lista de atividades - ALL.csv"
	_data_extraction(csv_file_path_activities)
	_on_buttonglobal_pressed()

func _data_extraction(csv_file_path_activities):
	var file = FileAccess.open(csv_file_path_activities, FileAccess.READ)
	if file == null:
		print("erro ao abrir o arquivo de atividades")
	else:
		print("consegui abrir o arquivo de atividades")
		var _header = file.get_csv_line()
		_header = file.get_csv_line()
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
		file.close()
	
func getPlayer (player : Player):
	currentPlayer = player

func abaGlobal():
	$ScrollContainerLocal.visible = false
	$ScrollContainerGlobal.visible = true
	$ScrollContainerMinhas.visible = false
	vboxGlobal.custom_minimum_size = Vector2(10,14500)
	
	#The separation constant in vboxContainer is not working at all
	#For now, I will set the green rectangles position manually :|
	#Defining the size of the page accordingly to the num of items
	var sizeArray = allActivities.size()
	var sizePag = sizeArray * 290
	vboxGlobal.custom_minimum_size = Vector2(10,sizePag)
	
	var yg = 0
	for activity in allActivities:
		var activityRect = createRect(activity,yg)
		if not activity.available:
			activityRect.activityUnavailable()
		vboxGlobal.add_child(activityRect)
		yg = yg + 290 #setting the position

func abaLocal():
	$ScrollContainerLocal.visible = true
	$ScrollContainerGlobal.visible = false
	$ScrollContainerMinhas.visible = false
	var activitiesFromCity = currentPlayer.playercurrentCity.getCityActivities()
	
	#Defining the size of the page accordingly to the num of items
	var sizeArray = activitiesFromCity.size()
	var sizePag = sizeArray * 290
	vboxLocal.custom_minimum_size = Vector2(10,sizePag)
	
	var yl = 0
	for i in activitiesFromCity:
		var activity = allActivities[int(i) -1]
		var activityRect = createRect(activity, yl)
		
		if not activity.available:
			activityRect.activityUnavailable()
		else:
			activityRect.showButtonPlay()
		vboxLocal.add_child(activityRect)
		
		yl = yl + 290

func abaMinhas():
	$ScrollContainerLocal.visible = false
	$ScrollContainerGlobal.visible = false
	$ScrollContainerMinhas.visible = true
	var activitiesFromPlayer = currentPlayer.getActivitiesPlayer()
	var listM = []
	var sizeArray = activitiesFromPlayer.size()
	if sizeArray > 0:
		var sizePag = sizeArray * 290
		vboxMinhas.custom_minimum_size = Vector2(10,sizePag)
		
		var ym = 0
		for i in activitiesFromPlayer:
			var activity = i
			var activityRect = createRect(activity, ym)
			
			var totalSeconds = activity.getTimeLeftInt()
			if totalSeconds == 0 :
				activityRect.setTime("Concluída")
			else:
				var minu = totalSeconds/60
				var sec = totalSeconds%60
				var time_string = "%02d:%02d" % [minu, sec]
				activityRect.setTime("Tempo Restante: " + time_string)
			
			listM.append(activityRect)
			vboxMinhas.add_child(activityRect)
			ym = ym + 290
			
		while $ScrollContainerMinhas.visible:
			for i in listM.size():
				var totalSeconds = activitiesFromPlayer[i].getTimeLeftInt()
				var activityRect = listM[i]
				if totalSeconds == 0 :
					activityRect.setTime("Concluída")
				else:
					var minu = totalSeconds/60
					var sec = totalSeconds%60
					var time_string = "%02d:%02d" % [minu, sec]
					activityRect.setTime("Tempo Restante: " + time_string)
			await get_tree().create_timer(0.2).timeout


func createRect(activity : Activity, y : int):
	var activityRect = greenRectScene.instantiate()
	var minready = (activity.timeToReady)/60
	
	activityRect.setTitle(activity.title)
	activityRect.setPrice("Custo: " + str(activity.priceCoins))
	activityRect.setTime("Tempo: " + str(minready) + " Min")
	activityRect.setQuestions("Perguntas: " + str(activity.numQuestActivity))
	activityRect.setCity(activity.city)
	activityRect.setActivityId(activity.idActivity)
	activityRect.position = Vector2(0,y) #setting the position
		
	activityRect.connect("activityPlay", activityPlay)
	
	return activityRect

func activityPlay(activityId):
	self.visible = false
	var activity = allActivities[activityId-1]
	activityPlayObject.emit(activity)
	

func _on_back_button_pressed():
	self.visible = false
	_on_buttonglobal_pressed()


func _on_buttonglobal_pressed():
	buttonLocal.button_pressed = false
	buttonMinhas.button_pressed = false
	buttonLocal.disabled = false
	buttonMinhas.disabled = false
	buttonGlobal.disabled = true
	abaGlobal()
	

func _on_buttonlocal_pressed():
	buttonGlobal.button_pressed = false
	buttonMinhas.button_pressed = false
	buttonLocal.disabled = true
	buttonMinhas.disabled = false
	buttonGlobal.disabled = false
	abaLocal()


func _on_buttonminhas_pressed():
	buttonLocal.button_pressed = false
	buttonGlobal.button_pressed = false
	buttonLocal.disabled = false
	buttonMinhas.disabled = true
	buttonGlobal.disabled = false
	abaMinhas()
