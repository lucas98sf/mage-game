extends CharacterBody2D

@export var DEBUG = false
var SPEED = 110.0
var JUMP_VELOCITY = -125.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var coyote_timer = $CoyoteTimer
@onready var jump_timer = $JumpTimer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping = false

func _physics_process(delta):
	# Add the gravity.
	if is_on_floor():
		is_jumping = false
		if not is_jumping:
			coyote_timer.start()
	else:
		if coyote_timer.time_left == 0:
			velocity.y += gravity * delta

	if DEBUG:
		if coyote_timer.time_left > 0 and coyote_timer.time_left < coyote_timer.wait_time:
				animated_sprite.modulate = Color(1, 0.5, 0.5, 1)
		else:
			animated_sprite.modulate = Color(1, 1, 1, 1)

	var can_jump = coyote_timer.time_left > 0 or jump_timer.time_left > 0

	if DEBUG:
		if can_jump:
				animated_sprite.modulate = Color(0.5, 0.5, 0.5, 1)
		else:
			animated_sprite.modulate = Color(1, 1, 1, 1)

	# Handle jump.
	if Input.is_action_pressed("ui_accept") and can_jump:
		if jump_timer.time_left == 0:
			jump_timer.start()
		is_jumping = true
		coyote_timer.stop()
		velocity.y = JUMP_VELOCITY * (1 + (jump_timer.time_left / 4))

	if DEBUG:
		if (velocity.y < 0):
			print(velocity.y)
			
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if direction != 0:
		animated_sprite.play("run")
		if direction > 0:
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true
	else:
		animated_sprite.play("idle")

	move_and_slide()
