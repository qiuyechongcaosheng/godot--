extends Node
var score = 0

@onready var game_manager = %GameManager
@onready var score_label = $ScoreLabel


func add_point():
	score += 1
	score_label.text = "金币数量:" +str(score)
