extends Area2D


func _physics_process(delta):
	for i in get_overlapping_areas():
		if i.is_in_group("Ball"):
			i.ver.x=5
	var y1 = Input.get_action_raw_strength("玩家1上")*4
	var y2 = Input.get_action_raw_strength("玩家1下")*4
	var y3 =position.y-y1+y2
	if y3 >48:
		if y3<600:
			position.y=position.y-y1+y2
