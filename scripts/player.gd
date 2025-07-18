extends CharacterBody2D


const SPEED = 75
const JUMP_VELOCITY = -400.0
@onready var base_sprite_animation: AnimatedSprite2D = $BaseSpriteAnimation
@onready var hair_sprite_animation: AnimatedSprite2D = $HairSpriteAnimation
@onready var tool_sprite_animation: AnimatedSprite2D = $ToolSpriteAnimation


func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		base_sprite_animation.flip_h = false
		hair_sprite_animation.flip_h = false
		tool_sprite_animation.flip_h = false
	elif direction < 0:
		base_sprite_animation.flip_h = true
		hair_sprite_animation.flip_h = true
		tool_sprite_animation.flip_h = true
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
