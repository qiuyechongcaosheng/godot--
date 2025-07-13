extends Control

@onready var scoreLabel:Label = $Score;
@onready var level:Label = $Levels;
@onready var speed_label:Label = $Speed;

var lines:int = 0;
var score:int = 0;
var speed:int = 0;

	# 设置目标帧率
	

#消行之后增加
func add_level(value:int):
	lines += value;
	level.text = str(lines);
	score += Globals.add_score[value - 1];
	scoreLabel.text = str(score);
	
#等级
func reset():
	lines = 0;
	score = 0;
	level.text = str(lines);
	scoreLabel.text = str(score);
	 

func check_speed():
	var index:int =Globals.level_score.size() - 1;
	var temp_speed:int = 1;
	
	for i in Globals.level_score.size():
		if score < Globals.level_score[index]:
			index -= 1;
		else :
			temp_speed = index + 1;
	if speed != temp_speed:
		speed = temp_speed;
		speed_label.text = str(speed);
		owner.set_wait_time(1-speed*0.1);
		
