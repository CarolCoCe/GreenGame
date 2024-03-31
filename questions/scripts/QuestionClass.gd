extends Node

class_name Question

var id : int
var question : String
var answer : String

func _init( p_id : int, p_question : String, p_answer : String):
	self.id = p_id
	self.question = p_question
	self.answer = p_answer
		
