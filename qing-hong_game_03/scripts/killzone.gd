extends Area2D


# Called when the node enters the scene tree for the first time.

@onready var timer = $Timer
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

@onready var animated_sprite_2d = $AnimatedSprite2D



	#animated_sprite_2d.play("die")

func _on_body_entered(body):
	print("你死了！")
	audio_stream_player_2d.playing = true
	
	timer.start()


func _on_timer_timeout():
	get_tree().reload_current_scene()
