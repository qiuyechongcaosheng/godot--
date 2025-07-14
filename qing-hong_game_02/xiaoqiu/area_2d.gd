extends Area2D

var vec:Vector2=Vector2(2,2)
var init_postiton
# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_to_group("Ball")
	init_postiton=position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position=position+vec
	

func rest():
	if vec.x>0:
		CountScore.score1=CountScore.score1+1
	else:
		CountScore.score2=CountScore.score2+1
	position=init_postiton
