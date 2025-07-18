extends CharacterBody2D


const SPEED = 75
const JUMP_VELOCITY = -400.0
@onready var base_sprite_animation: AnimatedSprite2D = $BaseSpriteAnimation
@onready var hair_sprite_animation: AnimatedSprite2D = $HairSpriteAnimation
@onready var tool_sprite_animation: AnimatedSprite2D = $ToolSpriteAnimation

var direction : Vector2


func _physics_process(delta: float) -> void:
	# Get horizontal direction
	var direction1 := Input.get_axis("move_left", "move_right")
	
	# Check movements inputs
	if Input.is_action_pressed("move_up"):
		direction = Vector2.UP
	elif Input.is_action_pressed("move_down"):
		direction = Vector2.DOWN
	elif Input.is_action_pressed("move_left"):
		direction = Vector2.LEFT
	elif Input.is_action_pressed("move_right"):
		direction = Vector2.RIGHT
	else:
		direction = Vector2.ZERO
	
	# Flipping the sprite
	if direction == Vector2.RIGHT: # Right
		base_sprite_animation.flip_h = false
		hair_sprite_animation.flip_h = false
		tool_sprite_animation.flip_h = false
	elif direction == Vector2.LEFT: # Left
		base_sprite_animation.flip_h = true
		hair_sprite_animation.flip_h = true
		tool_sprite_animation.flip_h = true
		
	# Play animations
	if direction == Vector2.ZERO:
		base_sprite_animation.play("idle_base")
		hair_sprite_animation.play("idle_hair")
		tool_sprite_animation.play("idle_tool")
	else:
		base_sprite_animation.play("walking_base")
		hair_sprite_animation.play("walking_hair")
		tool_sprite_animation.play("walking_tool")
		
	# Apply the speed
	velocity = direction * SPEED
	"""if direction1:
		velocity.x = direction1 * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)"""

	move_and_slide()
