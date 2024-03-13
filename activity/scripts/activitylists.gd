extends Node2D

@onready var painel = $Painel
@onready var vbox = $Painel/ScrollContainer/VBoxContainer

var greenRectScene = preload("res://activity/scenes/GreenRect.tscn")

var allActivities = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var valueNormal = load("res://assets/fa_arrow-circle-left.png")
	var valuePressed = load("res://assets/fa_arrow-circle-left (1).png")
	painel.setTextureButtonBack(valueNormal, valuePressed)
	painel.setTitle("Atividades")
	
	var csv_file_path_activities: String = "res://Data/Lista de atividades/Lista de atividades - Copy of ALL (1).csv"

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
				
				var activity = Activity.new(idf, titlef,priceCoinsf,numQuestActivityf,rewardCoinsf,rewardKnowledgeGemsf,temperatureRisef,timeToReadyf,rewardStoryf)
				
				allActivities.append(activity)
				
				var minready = timeToReadyf/60
				var activityRect = greenRectScene.instantiate()
				activityRect.setTitle(titlef)
				activityRect.setPrice("Custo: " + line[3])
				activityRect.setTime("Tempo de retorno: " + str(minready) + "Min")
				activityRect.setQuestions("Perguntas: " + line[4])
				vbox.add_child(activityRect)
		file.close()
	
	
