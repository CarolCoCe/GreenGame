extends Node2D

@onready var painel = $Painel
@onready var vbox = $Painel/ScrollContainer/VBoxContainer

var greenRectScene = load("res://activity/scenes/GreenRect.tscn")

var allActivities = []

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

		file.close()
	abaGlobal()

func abaGlobal():
	#The separation constant in vboxContainer is not working at all
	#For now, I will set the green rectangles position manually :|
	
	var y = 0
	for activity in allActivities:
		createRect(activity,y)
		y = y + 250 #setting the position


#func abaLocal(id1 : int, id2 : int = 0, id3 : int = 0):
	#var activity = allActivities[id1]
	#createRect(activity)
	#
	#if id2 != 0:
		#activity = allActivities[id2]
		#createRect(activity)
	#
	#if id3 != 0:
		#activity = allActivities[id1]
		#createRect(activity)


func createRect(activity : Activity, y):
	var activityRect = greenRectScene.instantiate()
	var minready = (activity.timeToReady)/60
	
	vbox.add_child(activityRect)
	activityRect.setTitle(activity.title)
	activityRect.setPrice("Custo: " + str(activity.priceCoins))
	activityRect.setTime("Tempo de retorno: " + str(minready) + "Min")
	activityRect.setQuestions("Perguntas: " + str(activity.numQuestActivity))
	activityRect.setCity(activity.city)
	activityRect.position = Vector2(0,y) #setting the position
	
	print (activityRect.position)


func _on_back_button_pressed():
	self.visible = false
