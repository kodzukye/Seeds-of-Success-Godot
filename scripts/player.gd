# PlayerBody.gd (version modifiée)
extends CharacterBody2D

const SPEED = 4000
const SPRINT = SPEED * 1.75

@onready var base_sprite_animation: AnimatedSprite2D = $BaseSpriteAnimation
@onready var hair_sprite_animation: AnimatedSprite2D = $HairSpriteAnimation
@onready var tool_sprite_animation: AnimatedSprite2D = $ToolSpriteAnimation
@onready var state_machine: StateMachine = $StateMachine

# Variables supplémentaires pour les systèmes du jeu
var is_day_phase: bool = true
var can_interact: bool = true

# Tap vs Hold pour "sprint" (Left Shift)
var sprint_tap_window := 0.14     # secondes pour considérer un tap
var _sprint_pressed_time := -1.0  # < 0 = pas pressé
var _sprint_tap_requested := false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("sprint"):
		_sprint_pressed_time = 0.0
	elif event.is_action_released("sprint"):
		# Relâchement: si relâché rapidement -> roulade
		if _sprint_pressed_time >= 0.0 and _sprint_pressed_time <= sprint_tap_window:
			_sprint_tap_requested = true
		_sprint_pressed_time = -1.0

func _ready() -> void:
	# La state machine gère maintenant les états
	pass

func _physics_process(_delta: float) -> void:
	# La state machine gère le mouvement et les animations
	# On peut ajouter ici des systèmes spécifiques au jeu
	if _sprint_pressed_time >= 0.0:
		_sprint_pressed_time += _delta

# Méthodes utilitaires pour les états
func get_current_state() -> String:
	if state_machine:
		return state_machine.get_current_state_name()
	return ""

func is_moving() -> bool:
	return velocity.length() > 0

# Méthodes pour les interactions spécifiques au jeu
func can_farm() -> bool:
	return is_day_phase and can_interact

func can_combat() -> bool:
	return not is_day_phase and can_interact

func set_day_phase(is_day: bool) -> void:
	is_day_phase = is_day
	# Ici on pourrait changer vers des états spécifiques jour/nuit si nécessaire

func disable_movement() -> void:
	can_interact = false
	state_machine.change_state("idle")

func enable_movement() -> void:
	can_interact = true

func consume_sprint_tap() -> bool:
	# Appelé par les états pour déclencher une roulade une seule fois
	if _sprint_tap_requested:
		_sprint_tap_requested = false
		return true
	return false
