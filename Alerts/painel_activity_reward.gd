extends PainelGeral


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

	
func show_reward(activity : Activity):
	$Panel/Title2.text = activity.title
	$Panel/Panel/story.text = activity.rewardStory
	$Panel/Panel/tempIncrease.text = str(activity.temperatureRise)
	$Panel/Panel/coins.text = str(activity.rewardCoins)
	$Panel/Panel/kgem.text = str(activity.rewardKnowledgeGems)
	self.visible = true
	print("era pro painel estar aparecendo")
