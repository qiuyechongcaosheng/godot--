extends Area2D

@onready var game_manager = %GameManager
# Called when the node enters the scene tree for the first time.


@onready var animation_player = $AnimationPlayer


func _on_body_entered(body):
	
	
	game_manager.add_point()
	
	animation_player.play("pickup")
