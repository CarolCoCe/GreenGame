extends PainelGeral

var allQuestions = []
var usedQuestions = []
var answerExpected
var numQuestionsLeft

signal quizEnded (quizResult)

func _ready():
	self.visible = false
	setTitle("Perguntas")
	var csv_file_path_questions: String = "res://Data/Perguntas/Perguntas Sustentabilidade - Sheet1.csv"
	_data_extraction(csv_file_path_questions)

func _data_extraction(csv_file_path_activities):
	var file = FileAccess.open(csv_file_path_activities, FileAccess.READ)
	if file == null:
		print("erro ao abrir o arquivo de perguntas")
	else:
		print("consegui abrir o arquivo de perguntas")
		var _header = file.get_csv_line()
		var id = 0
		while !file.eof_reached():
			var line = file.get_csv_line()
			if len(line) >= 2:
				var questionf = str(line[0])
				var answerf = str(line[1])
				
				var question = Question.new(id,questionf,answerf)
				allQuestions.append(question)
				id = id + 1
		file.close()

func pickUpRandomQuestion (deck, usedDeck): # Controls the used deck too
	if (usedDeck.size() >= deck.size()):
		usedDeck = []
		
	var randomIndex = randi_range(0, deck.size()-1)
	while (usedDeck.find(randomIndex) != -1):
		randomIndex = randi_range(0, deck.size()-1)
	var randomQuestion = deck[randomIndex]
	usedDeck.append(randomIndex)
	
	return randomQuestion

func startQuiz (numberQuestions : int):
	show_alert()
	numQuestionsLeft = numberQuestions
	nextQuestion()

func nextQuestion():
	if numQuestionsLeft > 0:
		var questionChosen = pickUpRandomQuestion(allQuestions,usedQuestions)
		$Panel/Panel/questionText.text = questionChosen.question
		answerExpected = questionChosen.answer
	else :
		quizEnded.emit("ok")

func _on_button_false_pressed():
	if answerExpected == "F":
		numQuestionsLeft = numQuestionsLeft - 1
		nextQuestion()
	else:
		numQuestionsLeft = 0
		quizEnded.emit("wrong")
	

func _on_button_true_pressed():
	if answerExpected == "V":
		numQuestionsLeft = numQuestionsLeft - 1
		nextQuestion()
	else:
		numQuestionsLeft = 0
		quizEnded.emit("wrong")
