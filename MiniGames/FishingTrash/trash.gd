extends CharacterBody2D

var movement_time = 1

var min_position = 100
var max_position = 584

var min_target = -200
var max_target = 200

var speed: float = 70
var totalTime : float = 0
var progress : float = 0
var currentTime : float = 0
var originPosition = self.position
var desloc : float = 0
var targetPosition: Vector2


func _ready():
	plan_move()

func  plan_move():
	desloc = randi_range(min_target, max_target)

	while (self.position.y + desloc <= min_position or self.position.y + desloc >= max_position or abs(desloc) < 50):
		desloc = randi_range(min_target, max_target)
	
	progress = 0
	totalTime = abs(desloc) / speed
	originPosition = self.position
	targetPosition = Vector2(self.position.x, self.position.y + desloc)
	

func _process(delta):
	if self.position != targetPosition:
		self.position = Vector2(self.position.x, originPosition.y + desloc * progress)
		progress = ease_out_sine(currentTime/totalTime)
		currentTime += delta
		
	if currentTime > totalTime:
		plan_move()
		currentTime = 0
		
func ease_out_sine(x: float) -> float:
	return sin((x * PI) / 2)
