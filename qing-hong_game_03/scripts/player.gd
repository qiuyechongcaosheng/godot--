extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -300.0
@onready var animated_sprite = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var jump_music = $jump_music



func _physics_process(delta):
	
	if not is_on_floor():
		
		velocity.y += gravity * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("jump" ):
		jump_music.playing = true 
	# Add the gravity.
	
	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction <0:
		animated_sprite.flip_h = true
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
		
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("ldie")
		else :
			animated_sprite.play("run")
	else :
			animated_sprite.play("jump")
				
	

	move_and_slide()
