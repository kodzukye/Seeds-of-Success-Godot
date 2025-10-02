# Roll.gd
class_name RollState
extends State

@export var roll_duration: float = 0.5           # Durée de la roulade
@export var roll_speed: float = 275.0            # Vitesse de pointe px/s
@export var speed_curve: Curve                     # Optionnel: courbe de vitesse (0..1 -> facteur)
@export var i_frames: float = 0.16                 # Invincibilité (s) pendant la roulade (0 pour désactiver)

var _t := 0.0
var _dir := Vector2.ZERO
var _iframes_left := 0.0

func enter() -> void:
	_t = 0.0
	_iframes_left = i_frames
	# Direction de roulade = dernière direction entrée, ou facing horizontal si neutre
	_dir = _get_input_dir()
	if _dir == Vector2.ZERO:
		# fallback: utilise le flip pour choisir droite/gauche
		_dir = Vector2.RIGHT if not player.base_sprite_animation.flip_h else Vector2.LEFT
	else:
		_dir = _dir.normalized()
	# Jouer l'animation de roll
	player.base_sprite_animation.play("roll")
	player.hair_sprite_animation.play("roll")
	player.tool_sprite_animation.play("roll")
	# Optionnel: basculer couches/collisions pour i-frames selon le projet
	_set_invincible(true)

func update(delta: float) -> String:
	_t += delta / max(roll_duration, 0.001)
	if _t > 1.0:
		_t = 1.0
	
	# Facteur de vitesse via courbe ou profil par défaut (sortie rapide puis amorti)
	var factor := 1.0
	if speed_curve:
		factor = clampf(speed_curve.sample(_t), 0.0, 1.0)
	else:
		# Profil doux: accélère vite au début puis décélère
		# factor = 1 - (2t-1)^2 => cloche entre 0..1
		var x := 2.0 * _t - 1.0
		factor = 1.0 - (x * x)
	
	# Déplacement: velocity en px/s, move_and_slide gère delta
	player.velocity = _dir * roll_speed * max(factor, 0.0)
	_handle_sprite_flipping(_dir)
	player.move_and_slide()
	
	# I-frames countdown
	if _iframes_left > 0.0:
		_iframes_left -= delta
		if _iframes_left <= 0.0:
			_set_invincible(false)
	
	# Fin -> choisir état suivant en fonction des inputs
	if _t >= 1.0:
		player.velocity = Vector2.ZERO
		_set_invincible(false)
		if _has_move_input():
			return "run" if Input.is_action_pressed("sprint") else "walking"
		return "idle"
	
	return ""

func exit() -> void:
	_set_invincible(false)

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

func _handle_sprite_flipping(direction: Vector2) -> void:
	if direction.x > 0.0:
		player.base_sprite_animation.flip_h = false
		player.hair_sprite_animation.flip_h = false
		player.tool_sprite_animation.flip_h = false
	elif direction.x < 0.0:
		player.base_sprite_animation.flip_h = true
		player.hair_sprite_animation.flip_h = true
		player.tool_sprite_animation.flip_h = true

func _set_invincible(active: bool) -> void:
	# Adapter selon le système de dégâts de ton projet
	# Exemples (au choix) :
	# - Désactiver la couche de collision "hurtbox"
	# - Déplacer collision mask temporairement
	# - Flag custom sur le joueur
	if player.has_method("set_invincible"):
		player.set_invincible(active)
