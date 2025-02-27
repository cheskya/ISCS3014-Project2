# I hereby attest to the truth of the following facts:
#
# I have not discussed the GDScript code in my program with anyone
# other than my instructor or the teaching assistants assigned to this course.
# 
# I have not used GDScript code obtained from another student, or
# any other unauthorized source, whether modified or unmodified.
#
# If any GDScript code or documentation used in my program was
# obtained from another source, it has been clearly noted with citations in the
# comments of my program.

extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -320.0

var isClimbing = false
var XDirection
var YDirection

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if not is_on_floor() and not isClimbing:
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor() and not isClimbing:
		velocity.y = JUMP_VELOCITY

	if isClimbing:
		XDirection = Input.get_axis("move_left", "move_right")
		YDirection = Input.get_axis("move_up", "move_down")
	else:
		XDirection = Input.get_axis("move_left", "move_right")   

	if XDirection:
		velocity.x = XDirection * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if isClimbing:
		if YDirection:  
			velocity.y = YDirection * SPEED
		else:
			velocity.y = move_toward(velocity.x, 0, SPEED)
			
	if XDirection > 0:
		animated_sprite.flip_h = false
	elif XDirection < 0:
		animated_sprite.flip_h = true

	if isClimbing:
		animated_sprite.play("climb")
	elif not is_on_floor():
		animated_sprite.play("jump")
	elif XDirection != 0 and velocity.x != 0 and not is_on_wall():
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")
	
	move_and_slide()

func _on_special_tile_check_body_entered(body: Node2D) -> void:
	isClimbing = true
	pass  

func _on_special_tile_check_body_exited(body: Node2D) -> void:
	isClimbing = false
	pass
