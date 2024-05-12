extends Node


class_name Activity
var idActivity : int
var title : String
var priceCoins : int
var numQuestActivity : int
var rewardCoins : int
var rewardKnowledgeGems : int
var temperatureRise : float
var timeToReady : int
var timeLeft : Timer
var rewardStory : String
var city : String
var available : bool = true

signal activityFinished (activity: Activity)

func _init(
		p_idActivity : int,
		p_title : String,
		p_priceCoins : int,
		p_numQuestActivity : int,
		p_rewardCoins : int,
		p_rewardKnowledgeGems : int,
		p_temperatureRise : float,
		p_timeToReady : int,
		p_rewardStory : String,
		p_city : String,
	):
	self.idActivity = p_idActivity
	self.title = p_title
	self.priceCoins = p_priceCoins
	self.numQuestActivity = p_numQuestActivity
	self.rewardCoins = p_rewardCoins
	self.rewardKnowledgeGems = p_rewardKnowledgeGems
	self.temperatureRise = p_temperatureRise
	self.timeToReady = p_timeToReady
	self.rewardStory = p_rewardStory
	self.city = p_city
	self.timeLeft = Timer.new()
	self.timeLeft.wait_time = timeToReady
	self.timeLeft.connect("timeout", timeLefTimeOut)
	self.timeLeft.one_shot = true
	add_child(timeLeft)
	
func timeLefTimeOut():
	print("timeout da atividade")
	activityFinished.emit(self)

func startTimer():
	self.timeLeft.start()

func getTimeLeftInt():
	return int(timeLeft.time_left)

