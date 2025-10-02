# Walk.gd
class_name WalkState
extends State

func enter() -> void:
	play_walk_animations()

func update(delta: float) -> String:
	var direction = get_movement_direction()
	
	# Tap sprint = roll
	if player.consume_sprint_tap():
		return "roll"
	
	# Si pas de direction, retourner à idle
	if direction == Vector2.ZERO:
		return "idle"
	
	# Si sprint pressé pendant la marche, passer en run
	if Input.is_action_pressed("sprint"):
		return "run"
		
	if Input.is_action_just_pressed("jump"):
		return "jump"
	
	# Appliquer le mouvement
	player.velocity = direction * player.SPEED * delta
	handle_sprite_flipping(direction)
	player.move_and_slide()
	
	return ""

func get_movement_direction() -> Vector2:
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_up"):
		direction = Vector2.UP
	elif Input.is_action_pressed("move_down"):
		direction = Vector2.DOWN
	elif Input.is_action_pressed("move_left"):
		direction = Vector2.LEFT
	elif Input.is_action_pressed("move_right"):
		direction = Vector2.RIGHT
	
	return direction

func handle_sprite_flipping(direction: Vector2) -> void:
	if direction == Vector2.RIGHT:
		player.base_sprite_animation.flip_h = false
		player.hair_sprite_animation.flip_h = false
		player.tool_sprite_animation.flip_h = false
	elif direction == Vector2.LEFT:
		player.base_sprite_animation.flip_h = true
		player.hair_sprite_animation.flip_h = true
		player.tool_sprite_animation.flip_h = true

func play_walk_animations() -> void:
	player.base_sprite_animation.play("walking")
	player.hair_sprite_animation.play("walking")
	player.tool_sprite_animation.play("walking")
