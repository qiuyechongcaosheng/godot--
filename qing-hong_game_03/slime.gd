extends Node2D

const  speed = 60
@onready var ray_cast_2d_left = $RayCast2D_left
@onready var ray_cast_2d_right = $RayCast2D_right
@onready var animated_sprite_2d = $AnimatedSprite2D



var direction = 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ray_cast_2d_left.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = true


	if ray_cast_2d_right.is_colliding():
		direction = 1
		animated_sprite_2d.flip_h = false
		
	position.x += delta * speed * direction
