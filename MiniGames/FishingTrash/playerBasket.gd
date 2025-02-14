extends CharacterBody2D

var speed = 60.0
var maxVelocity = 600.0
var bounce = 1.5
var currentTimeDown = 1
var currentTimeUp = 0.5
var gravity = 0.02

var min_position = 100
var max_position = 584

var fishInside = false

signal _progress_increased
signal _progress_decreased

func _process(delta):
	$"../TimeLeft".text = str(int($"../Timer".time_left))
	fishing()
	if Input.is_action_pressed("mouse_left"):
		currentTimeDown = 1
		if self.position.y > min_position and self.position.y <= max_position:
			currentTimeUp += gravity
			self.velocity.y -= (speed * 1.2 * currentTimeUp) * delta
		elif self.position.y >= max_position:
			self.position.y = max_position
		else:
			self.position.y = min_position
			
	else:
		currentTimeDown += gravity
		currentTimeUp = 1
		if self.position.y < max_position and self.position.y >= min_position:
			self.velocity.y = min((self.velocity.y + speed * 0.6 * currentTimeDown * delta) , maxVelocity)
		elif self.position.y <= min_position:
			self.position.y = min_position
		else:
			self.position.y = max_position
	move_and_slide()
	
	if self.position.y >= max_position:
		if abs(self.velocity.y) >= 1:
			# print(self.velocity)
			self.velocity.y /= -bounce
		else:
			currentTimeUp = 1
			currentTimeDown = 1
			self.velocity.y = 0
	elif position.y <= min_position:
		self.velocity.y = 0

func fishing():
	if (fishInside):
		_progress_increased.emit()
			
	else:
		_progress_decreased.emit()

func _on_detect_body_entered(body):
	var bodyName = body.get_name()
	if ( bodyName == "trash"):
		fishInside = true


func _on_detect_body_exited(body):
	if (body.get_name() == "trash"):
		fishInside = false
