extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -320.0

var isClimbing : bool = false
var XDirection
var YDirection

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and not isClimbing:
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and not isClimbing:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if isClimbing:
		XDirection = Input.get_axis("move_left", "move_right")
		YDirection = Input.get_axis("move_up", "move_down")
	else:
		XDirection = Input.get_axis("move_left", "move_right")   

	if XDirection:
		velocity.x = XDirection * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# velcoity.y should only be modified this way if climbing
	if isClimbing:
		if YDirection:  
			velocity.y = YDirection * SPEED
		else:
			velocity.y = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_special_tile_check_body_entered(body: Node2D) -> void:
	isClimbing = true
	pass  

func _on_special_tile_check_body_exited(body: Node2D) -> void:
	isClimbing = false
	pass
