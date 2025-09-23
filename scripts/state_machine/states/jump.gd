# Jump.gd (version corrigée)
class_name JumpState
extends State

@export var hop_duration: float = 0.28        # Durée totale du saut (s)
@export var hop_speed_multiplier: float = 0.016  # Réduction de la vitesse pendant le saut
@export var hop_height: float = 20.0           # Hauteur visuelle (pixels)

var _t: float = 0.0
var _dir: Vector2 = Vector2.ZERO
var _base_off: Vector2
var _hair_off: Vector2
var _tool_off: Vector2

func enter() -> void:
	_t = 0.0
	_dir = _get_input_dir()
	if _dir != Vector2.ZERO:
		_dir = _dir.normalized()
	# Sauvegarder les offsets initiaux des sprites
	_base_off = player.base_sprite_animation.position
	_hair_off = player.hair_sprite_animation.position
	_tool_off = player.tool_sprite_animation.position
	# Anims de saut
	player.base_sprite_animation.play("jump")
	player.hair_sprite_animation.play("jump")
	player.tool_sprite_animation.play("jump")

func update(delta: float) -> String:
	# Avancement normalisé 0..1
	_t += delta / max(hop_duration, 0.001)
	if _t > 1.0:
		_t = 1.0
	
	# Hauteur parabolique: h = 4 t (1 - t) H
	var height := 4.0 * _t * (1.0 - _t) * hop_height
	_apply_sprite_height(height)
	
	# Déplacement horizontal réduit pendant le saut
	if _dir != Vector2.ZERO:
		# Utiliser une vitesse beaucoup plus faible pendant le saut
		player.velocity = _dir * player.SPEED * hop_speed_multiplier
	else:
		# Maintenir une légère inertie si on était en mouvement
		player.velocity = player.velocity * 0.8
	
	_handle_sprite_flipping(_dir)
	player.move_and_slide()
	
	# Fin du saut -> choisir l'état suivant
	if _t >= 1.0:
		_reset_sprite_offsets()
		player.velocity = Vector2.ZERO
		if _has_move_input():
			return "run" if Input.is_action_pressed("sprint") else "walking"
		return "idle"
	
	return ""

func exit() -> void:
	_reset_sprite_offsets()

func _get_input_dir() -> Vector2:
	var d := Vector2.ZERO
	d.y -= int(Input.is_action_pressed("move_up"))
	d.y += int(Input.is_action_pressed("move_down"))
	d.x -= int(Input.is_action_pressed("move_left"))
	d.x += int(Input.is_action_pressed("move_right"))
	return d

func _has_move_input() -> bool:
	return Input.is_action_pressed("move_up") \
		or Input.is_action_pressed("move_down") \
		or Input.is_action_pressed("move_left") \
		or Input.is_action_pressed("move_right")

func _apply_sprite_height(h: float) -> void:
	# Décaler uniquement l'affichage vers le haut pour simuler la hauteur
	player.base_sprite_animation.position = _base_off + Vector2(0, -h)
	player.hair_sprite_animation.position = _hair_off + Vector2(0, -h)
	player.tool_sprite_animation.position = _tool_off + Vector2(0, -h)

func _reset_sprite_offsets() -> void:
	player.base_sprite_animation.position = _base_off
	player.hair_sprite_animation.position = _hair_off
	player.tool_sprite_animation.position = _tool_off

func _handle_sprite_flipping(direction: Vector2) -> void:
	if direction.x > 0.0:
		player.base_sprite_animation.flip_h = false
		player.hair_sprite_animation.flip_h = false
		player.tool_sprite_animation.flip_h = false
	elif direction.x < 0.0:
		player.base_sprite_animation.flip_h = true
		player.hair_sprite_animation.flip_h = true
		player.tool_sprite_animation.flip_h = true
