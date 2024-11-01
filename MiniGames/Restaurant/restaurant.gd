extends Node2D

var protein = 0
var fiber = 0
var carbon = 0

signal plate (protein, fiber, kgCarbon)

var foods = {
#food : [protein, fiber, carbon]
	"Cheese": [25,0,2.5],
	"Carrot": [0.9,2.8,0.06],
	"Peas": [5.4,5.1,0.2],
	"Fries": [3.4,3.8,1,2],
	"Beef": [26.1,0,27],
	"Corn": [3.2,2.7,0.3],
	"Banana": [1.1,2.6,0.1],
	"Bacon": [37,0,11],
	"Tomatoes": [0.9,1.2,0.2],
	"Lettuce": [1.4,1.1,0.05],
	"Fish": [19.8,0,6.1],
	"Bread": [8,2.7,0.65],
	"Pasta": [5,3.2,0.48],
	"Falafel": [13,5.5,0.45],
	"Chicken": [20.3,0,6.9],
	"Rice": [2.4,1,0.65],
	"Broccoli": [2.8,3.3,0.25],
	"Egg": [12.6,0,0.52],
	"Beans": [8.9,6.4,0.3],
	"Cocumber": [0.7,0.5,0.04],
}

func startTimer():
	$Timer.start(31)

func _ready():
	$Ready.disabled = true
	for buttonString in foods.keys():
		var buttonFood = get_node(buttonString)
		buttonFood.connect("pressed", onPressedFoods.bind(buttonString))

func _process(_delta):
	$timeLeft.text = str(int($Timer.time_left))

func plateFinished():
	$Timer.paused = true
	plate.emit(protein,fiber,carbon)

func onPressedFoods(buttonString):
	if buttonString in foods: 
		protein = protein + foods[buttonString][0]
		fiber = fiber + foods[buttonString][1]
		carbon = carbon + foods[buttonString][2]
		var buttonFood = get_node(buttonString)
		buttonFood.disabled = true
		
		$ProgressBarProtein.value = protein
		$ProgressBarFiber.value = fiber
		
		if protein >= 20 and fiber>= 10:
			$Ready.disabled = false
		
