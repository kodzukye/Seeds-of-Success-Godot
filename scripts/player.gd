extends CharacterBody2D


const SPEED = 4000
const SPRINT = SPEED * 1.75
@onready var base_sprite_animation: AnimatedSprite2D = $BaseSpriteAnimation
@onready var hair_sprite_animation: AnimatedSprite2D = $HairSpriteAnimation
@onready var tool_sprite_animation: AnimatedSprite2D = $ToolSpriteAnimation

var direction : Vector2
var is_sprinting = false


func _physics_process(delta: float) -> void:
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
		
	if Input.is_action_pressed("sprint"):
		is_sprinting = true
	else:
		is_sprinting = false
	
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
		
	elif is_sprinting and direction != Vector2.ZERO:
		base_sprite_animation.play("running_base")
		hair_sprite_animation.play("running_hair")
		tool_sprite_animation.play("running_tool")
		
	else:
		base_sprite_animation.play("walking_base")
		hair_sprite_animation.play("walking_hair")
		tool_sprite_animation.play("walking_tool")
		
	# Apply the speed
	if is_sprinting and direction != Vector2.ZERO:
		velocity = delta * direction * SPRINT
	else:
		velocity = delta * direction * SPEED

	move_and_slide()
