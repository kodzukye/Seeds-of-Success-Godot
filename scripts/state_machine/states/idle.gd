# Idle.gd
class_name IdleState
extends State

func enter() -> void:
	player.velocity = Vector2.ZERO
	play_idle_animations()

func update(delta: float) -> String:
	# Vérifier les inputs de mouvement
	if Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down") or \
	   Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		if Input.is_action_pressed("sprint"):
			return "run"
		else:
			return "walking"
			
	if Input.is_action_just_pressed("jump"):
		return "jump"
	
	# Rester en idle si aucun input
	return ""

func play_idle_animations() -> void:
	if player.has_method("get_base_sprite") or player.get("base_sprite_animation"):
		player.base_sprite_animation.play("idle")
		player.hair_sprite_animation.play("idle")
		player.tool_sprite_animation.play("idle")
